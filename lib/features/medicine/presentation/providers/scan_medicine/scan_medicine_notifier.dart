import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/scan_task.dart';
import '../../../domain/usecases/scan_medication.dart';
import '../../../domain/usecases/delete_scan_task.dart';
import '../../../domain/usecases/create_user_medication.dart';
import '../medicine/medicine_provider.dart';

enum ScanType { prescription, medicineBox }

class ScanMedicineState {
  final bool isLoading;
  final String? errorMessage;
  final String? imagePath;
  final String? recognizedText;
  final ScanType? scanType;

  ScanMedicineState({
    this.isLoading = false,
    this.errorMessage,
    this.imagePath,
    this.recognizedText,
    this.scanType,
  });

  ScanMedicineState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? imagePath,
    String? recognizedText,
    ScanType? scanType,
  }) {
    return ScanMedicineState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      imagePath: imagePath ?? this.imagePath,
      recognizedText: recognizedText ?? this.recognizedText,
      scanType: scanType ?? this.scanType,
    );
  }
}

Future<String> _runOcr(String imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  try {
    final inputImage = InputImage.fromFilePath(imagePath);
    final result = await textRecognizer.processImage(inputImage);
    return result.text.trim();
  } finally {
    await textRecognizer.close();
  }
}

class ScanMedicineNotifier extends StateNotifier<ScanMedicineState> {
  final Ref ref;
  final ScanMedication _scanMedication;
  final CreateUserMedication _createUserMedication;
  final DeleteScanTask _deleteScanTask;
  bool _disposed = false;

  ScanMedicineNotifier(
    this.ref,
    this._scanMedication,
    this._createUserMedication,
    this._deleteScanTask,
  ) : super(ScanMedicineState()) {
    Future.microtask(_checkLostData);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeSetState(ScanMedicineState newState) {
    if (_disposed || !mounted) return;
    state = newState;
  }

  Future<void> _checkLostData() async {
    try {
      final picker = ImagePicker();
      final response = await picker.retrieveLostData();
      if (_disposed || !mounted) return;
      if (response.isEmpty || response.file == null) return;
      await _handleProcess(response.file!.path);
    } catch (_) {}
  }

  void setScanType(ScanType type) {
    _safeSetState(state.copyWith(scanType: type));
  }

  void onBack() {
    AppRouter.router.go(AppRoutes.addMedicine);
  }

  Future<void> onTakePhoto() async {
    await _handleScan(ImageSource.camera);
  }

  Future<void> onUploadPhoto() async {
    await _handleScan(ImageSource.gallery);
  }

  Future<void> _handleScan(ImageSource source) async {
    _safeSetState(state.copyWith(isLoading: true, errorMessage: null));
    try {
      bool hasPermission = false;
      if (source == ImageSource.camera) {
        hasPermission = (await Permission.camera.request()).isGranted;
      } else {
        hasPermission = (await Permission.photos.request()).isGranted;
        if (!hasPermission) {
          hasPermission = (await Permission.storage.request()).isGranted;
        }
      }
      if (_disposed || !mounted) return;
      if (!hasPermission) {
        _safeSetState(
          state.copyWith(
            isLoading: false,
            errorMessage: 'medicine.scan.error_permission'.tr(),
          ),
        );
        return;
      }
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 20,
      );
      if (_disposed || !mounted) return;
      if (image == null) {
        _safeSetState(state.copyWith(isLoading: false));
        return;
      }
      await _handleProcess(image.path);
    } catch (e) {
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _handleProcess(String path) async {
    final keepAlive = ref.keepAlive();
    try {
      _safeSetState(state.copyWith(isLoading: true, imagePath: path));
      await Future.delayed(const Duration(milliseconds: 500));
      final textResult = await _runOcr(path);
      if (_disposed || !mounted) {
        keepAlive.close();
        return;
      }
      _safeSetState(
        state.copyWith(isLoading: false, recognizedText: textResult),
      );
      final lines = textResult
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      if (lines.isEmpty) {
        _safeSetState(
          state.copyWith(
            isLoading: false,
            errorMessage: 'medicine.scan.error_no_text'.tr(),
          ),
        );
        keepAlive.close();
        return;
      }
      final type = state.scanType == ScanType.medicineBox
          ? 'medicine_box'
          : 'prescription';
      final formattedText = state.scanType == ScanType.medicineBox
          ? lines.join(' ')
          : lines.join('\n');
      final scanTaskId = DateTime.now().millisecondsSinceEpoch.toString();
      final medicineNotifier = ref.read(medicineProvider.notifier);
      medicineNotifier.addScanTask(
        ScanTask(
          id: scanTaskId,
          createdAt: DateTime.now(),
          imagePath: path,
          status: ScanStatus.processing,
        ),
      );
      AppRouter.router.go(AppRoutes.medicine);
      try {
        final taskResult = await _scanMedication(
          scannedText: formattedText,
          rawData: {'lines': lines, 'type': type, 'imagePath': path},
        );
        medicineNotifier.updateScanTask(
          scanTaskId,
          taskResult.status,
          userMedications: taskResult.userMedications,
          newId: taskResult.id,
        );
      } catch (e) {
        medicineNotifier.updateScanTask(
          scanTaskId,
          ScanStatus.failed,
          errorMessage: e.toString(),
        );
      } finally {
        keepAlive.close();
      }
    } catch (e) {
      keepAlive.close();
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: e.toString()),
      );
    }
  }

  Future<bool> saveMedicinesToCabinet(String taskId) async {
    final medicineState = ref.read(medicineProvider);
    final medications = medicineState.reviewMedications;
    if (medications.isEmpty) return false;

    _safeSetState(state.copyWith(isLoading: true));
    try {
      for (final med in medications) {
        if (med['medicationId'] != null) {
          await _createUserMedication(
            medicationId: med['medicationId'],
            scannedData: med['scannedData'],
          );
        }
      }
      await _deleteScanTask(taskId);
      await ref.read(medicineProvider.notifier).fetchActiveMedications();
      _safeSetState(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: e.toString()),
      );
      return false;
    }
  }

  void onAddNew() => AppRouter.router.push(AppRoutes.scanMedicineBox);
  void onViewCabinet() => AppRouter.router.go(AppRoutes.medicine);
  void onComplete() => AppRouter.router.go(AppRoutes.home);

  void reset() {
    _safeSetState(ScanMedicineState(scanType: state.scanType));
  }
}
