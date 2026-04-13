import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/scan_task.dart';
import '../../../domain/usecases/scan_medication.dart';
import '../medicine/medicine_provider.dart';

enum ScanType { prescription, medicineBox }

/// State class for Scan Medicine
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

/// Runs OCR entirely off the main thread.
Future<String> _runOcr(String imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  try {
    final inputImage = InputImage.fromFilePath(imagePath);
    final result = await textRecognizer.processImage(inputImage);
    return result.text.trim();
  } finally {
    await textRecognizer.close(); // Always closed, even on error
  }
}

/// Notifier for Medicine Scanning (Prescription & Box)
class ScanMedicineNotifier extends StateNotifier<ScanMedicineState> {
  final Ref ref;
  final ScanMedication _scanMedication;
  bool _disposed = false;

  ScanMedicineNotifier({
    required this.ref,
    required ScanMedication scanMedication,
  }) : _scanMedication = scanMedication,
       super(ScanMedicineState()) {
    // Defer lost data check to avoid async work in constructor
    Future.microtask(_checkLostData);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Safe state update — no-op if notifier has been disposed
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
    } catch (_) {
      // Silently ignore lost data errors — non-critical path
    }
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
      // Request permissions
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
            errorMessage: 'Bạn cần cấp quyền để thực hiện tính năng này.',
          ),
        );
        return;
      }

      // Fresh ImagePicker each scan — prevents native SurfaceView reuse crash
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 20,
        maxWidth: 512,
        maxHeight: 512,
        requestFullMetadata: false,
      );

      if (_disposed || !mounted) return;

      if (image == null) {
        _safeSetState(state.copyWith(isLoading: false));
        return;
      }

      await _handleProcess(image.path);
    } catch (e) {
      _safeSetState(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã có lỗi xảy ra khi quét: ${e.toString()}',
        ),
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
            errorMessage: 'Không tìm thấy chữ trong ảnh. Vui lòng thử lại.',
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

      // 1. Add processing placeholder task to UI
      medicineNotifier.addScanTask(
        ScanTask(
          id: scanTaskId,
          createdAt: DateTime.now(),
          imagePath: path,
          status: ScanStatus.processing,
        ),
      );

      // 2. Navigate away — keepAlive ensures we stay alive for the API call
      AppRouter.router.go(AppRoutes.medicine);

      try {
        final taskResult = await _scanMedication(
          scannedText: formattedText,
          rawData: {'lines': lines, 'type': type, 'imagePath': path},
        );

        // medicineNotifier is NOT autoDispose, always safe to update
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
        // Release keepAlive — allow autoDispose to reclaim when ready
        keepAlive.close();
      }
    } catch (e) {
      keepAlive.close();
      _safeSetState(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Đã có lỗi xảy ra khi quét: ${e.toString()}',
        ),
      );
    }
  }

  /// Preserve scanType when resetting between scans
  void reset() {
    _safeSetState(ScanMedicineState(scanType: state.scanType));
  }
}
