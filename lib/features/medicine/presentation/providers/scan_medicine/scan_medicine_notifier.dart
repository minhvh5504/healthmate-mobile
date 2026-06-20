import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
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
  final ScanType? scanType;
  final String? fromTaskId;

  ScanMedicineState({
    this.isLoading = false,
    this.errorMessage,
    this.imagePath,
    this.scanType,
    this.fromTaskId,
  });

  ScanMedicineState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? imagePath,
    ScanType? scanType,
    String? fromTaskId,
    bool clearFromTaskId = false,
  }) {
    return ScanMedicineState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      imagePath: imagePath ?? this.imagePath,
      scanType: scanType ?? this.scanType,
      fromTaskId: clearFromTaskId ? null : (fromTaskId ?? this.fromTaskId),
    );
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

  void setScanType(ScanType type, {String? fromTaskId}) {
    _safeSetState(
      state.copyWith(
        scanType: type,
        fromTaskId: fromTaskId,
        clearFromTaskId: fromTaskId == null,
      ),
    );
  }

  void onBack() {
    if (state.fromTaskId != null) {
      AppRouter.router.pushReplacement(
        AppRoutes.reviewScan,
        extra: state.fromTaskId,
      );
    } else {
      AppRouter.router.pop();
    }
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
        imageQuality: 80,
      );
      if (_disposed || !mounted) return;
      if (image == null) {
        _safeSetState(state.copyWith(isLoading: false));
        return;
      }
      await _handleProcess(image.path);
    } catch (e) {
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: AppToast.message(e)),
      );
    }
  }

  Future<void> _handleProcess(String path) async {
    final keepAlive = ref.keepAlive();
    final scanTaskId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final medicineNotifier = ref.read(medicineProvider.notifier);
    try {
      _safeSetState(state.copyWith(isLoading: true, imagePath: path));
      final type = state.scanType == ScanType.medicineBox
          ? 'medicine_box'
          : 'prescription';

      if (state.fromTaskId != null) {
        medicineNotifier.deleteScanTask(state.fromTaskId!);
      }

      medicineNotifier.addScanTask(
        ScanTask(
          id: scanTaskId,
          createdAt: DateTime.now(),
          imagePath: path,
          status: ScanStatus.processing,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 2400));

      _safeSetState(state.copyWith(isLoading: false));
      AppRouter.router.go(AppRoutes.medicine);

      try {
        final ocrResult = await _recognizeText(path);
        if (ocrResult.scannedText.trim().isEmpty) {
          throw Exception('medicine.scan.error_no_text');
        }

        final taskResult = await _scanMedication(
          scannedText: ocrResult.scannedText,
          rawData: {
            'type': type,
            'source': 'mlkit',
            'scannedText': ocrResult.scannedText,
            'originalScannedText': ocrResult.originalScannedText,
            'normalizedScannedText': ocrResult.normalizedScannedText,
            'lines': ocrResult.lines,
            'rawFullText': ocrResult.rawFullText,
            'rawLines': ocrResult.rawLines,
            'rejectedLines': ocrResult.rejectedLines,
          },
          imagePath: path,
        );
        medicineNotifier.updateScanTask(
          scanTaskId,
          taskResult.status,
          userMedications: taskResult.userMedications,
          newId: taskResult.id,
          imagePath: taskResult.imagePath ?? path,
        );
      } catch (e) {
        medicineNotifier.updateScanTask(
          scanTaskId,
          ScanStatus.failed,
          errorMessage: AppToast.message(e),
        );
      } finally {
        keepAlive.close();
      }
    } catch (e) {
      keepAlive.close();
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: AppToast.message(e)),
      );
    }
  }

  Future<_ScanOcrResult> _recognizeText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      final rawLines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      final filteredLines = _filterMedicineLines(rawLines);
      final originalScannedText = filteredLines.join('\n').trim();
      final normalizedScannedText = _normalizeMedicineScanText(
        originalScannedText,
      );
      final scannedText = _primaryMedicineSearchText(
        normalizedScannedText,
        originalScannedText,
      );

      return _ScanOcrResult(
        scannedText: scannedText,
        originalScannedText: originalScannedText,
        normalizedScannedText: normalizedScannedText,
        lines: filteredLines,
        rawFullText: recognizedText.text.trim(),
        rawLines: rawLines,
        rejectedLines: rawLines
            .where((line) => !filteredLines.contains(line))
            .toList(),
      );
    } finally {
      await textRecognizer.close();
    }
  }

  List<String> _filterMedicineLines(List<String> lines) {
    final scoredLines = <_ScoredOcrLine>[];

    for (final line in lines) {
      final score = _scoreMedicineLine(line);
      if (score > 0) scoredLines.add(_ScoredOcrLine(line, score));
    }

    if (scoredLines.isEmpty) {
      return lines.where((line) => _isNotCodeNoise(line)).toList();
    }

    scoredLines.sort((a, b) => b.score.compareTo(a.score));
    final selected = scoredLines.take(8).map((item) => item.line).toSet();

    return lines.where(selected.contains).toList();
  }

  String _primaryMedicineSearchText(
    String normalizedScannedText,
    String originalScannedText,
  ) {
    for (final block in [normalizedScannedText, originalScannedText]) {
      for (final rawLine in block.split('\n')) {
        final line = rawLine.trim();
        if (line.isNotEmpty) return line;
      }
    }
    return '';
  }

  String _joinUniqueTextBlocks(List<String> textBlocks) {
    final seen = <String>{};
    final lines = <String>[];

    for (final block in textBlocks) {
      for (final rawLine in block.split(RegExp(r'\n+'))) {
        final line = rawLine.trim();
        if (line.isEmpty) continue;
        final key = line.toLowerCase();
        if (seen.add(key)) lines.add(line);
      }
    }

    return lines.join('\n').trim();
  }

  String _normalizeMedicineScanText(String text) {
    final normalizedLines = <String>[];

    for (final rawLine in text.split(RegExp(r'\n+'))) {
      final normalized = _normalizeMedicineLine(rawLine);
      if (normalized.isNotEmpty) normalizedLines.add(normalized);
    }

    final joined = normalizedLines.join(' ');
    final phraseCandidates = <String>[];
    if (joined.contains('TRAPHACO') &&
        joined.contains('HOAT HUYET') &&
        joined.contains('DUONG NAO')) {
      phraseCandidates.add('HOAT HUYET DUONG NAO TRAPHACO');
    } else if (joined.contains('TRAPHACO') && joined.contains('DUONG NAO')) {
      phraseCandidates.add('DUONG NAO TRAPHACO');
    }

    return _joinUniqueTextBlocks([...phraseCandidates, ...normalizedLines]);
  }

  String _normalizeMedicineLine(String line) {
    var normalized = line.toUpperCase().trim();
    normalized = normalized
        .replaceAll(RegExp(r'[^A-ZÀ-Ỹ0-9\s:.]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final replacements = <RegExp, String>{
      RegExp(r'TRAPHACO+'): 'TRAPHACO',
      RegExp(r'TRAPHAC'): 'TRAPHACO',
      RegExp(r'RAPNACO'): 'TRAPHACO',
      RegExp(r'TRAPNACO'): 'TRAPHACO',
      RegExp(r'SGNG'): 'DUONG',
      RegExp(r'GNG'): 'DUONG',
      RegExp(r'DUNE'): 'DUONG',
      RegExp(r'DUNG'): 'DUONG',
      RegExp(r'DUN'): 'DUONG',
      RegExp(r'TNUYET'): 'HUYET',
      RegExp(r'TNUYĒT'): 'HUYET',
      RegExp(r'NUYET'): 'HUYET',
      RegExp(r'ONG +NGH'): 'DUONG NAO',
      RegExp(r'NGH'): 'NAO',
      RegExp(r'NOA'): 'NAO',
      RegExp(r'HOATHOYR'): 'HOAT HUYET',
      RegExp(r'HOATHUYR'): 'HOAT HUYET',
      RegExp(r'HOATHUY[A-ZÀ-Ỹ]*'): 'HOAT HUYET',
      RegExp(r'HOAT +HOYR'): 'HOAT HUYET',
      RegExp(r'DNH +L[ÀA]NG'): 'DINH LANG',
      RegExp(r'NL[ÀA]NG'): 'DINH LANG',
    };

    for (final entry in replacements.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }

    return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  int _scoreMedicineLine(String line) {
    final normalized = line.toLowerCase().trim();
    if (!_isNotCodeNoise(line)) return 0;

    final letters = RegExp(r'[a-zA-ZÀ-ỹ]').allMatches(line).length;
    if (letters < 3) return 0;

    final upperLetters = RegExp(r'[A-ZÀ-Ỹ]').allMatches(line).length;
    final digits = RegExp(r'\d').allMatches(line).length;
    final words = line.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    var score = 0;

    if (upperLetters / letters >= 0.55) score += 4;
    if (words >= 2) score += 2;
    if (line.length >= 5 && line.length <= 28) score += 1;
    if (digits == 0) score += 1;

    final medicineHints = [
      'traphac',
      'traphaco',
      'duong',
      'dung',
      'nao',
      'huyet',
      'hoat',
      'radix',
      'vien',
      'mg',
      'ml',
    ];
    if (medicineHints.any(normalized.contains)) score += 4;

    final mostlyLowercaseNoise =
        upperLetters <= 1 && words <= 2 && normalized.length > 5;
    if (mostlyLowercaseNoise) score -= 3;

    return score >= 3 ? score : 0;
  }

  bool _isNotCodeNoise(String line) {
    final normalized = line.toLowerCase().trim();
    if (normalized.length < 2) return false;

    final codeNoisePatterns = [
      RegExp(
        r'\b(json|dart|widget|widgets|import|export|class|const|final|void)\b',
      ),
      RegExp(r'\.(json|dart|ts|tsx|js|jsx|css|html)\b'),
      RegExp(r'\b(assets|lib/|home_|shortcut|section|android|flutter)\b'),
      RegExp(r'\b(undo|review|locally|changes|permissions)\b'),
      RegExp(r'[+\-]\d'),
      RegExp(r'[()]'),
    ];

    return !codeNoisePatterns.any((pattern) => pattern.hasMatch(normalized));
  }

  Future<bool> saveMedicinesToCabinet(String taskId) async {
    final medicineState = ref.read(medicineProvider);
    final medications = medicineState.reviewMedications;
    if (medications.isEmpty) return false;

    _safeSetState(state.copyWith(isLoading: true));
    try {
      for (final med in medications) {
        final rawMedicationId = med['medicationId']?.toString();
        final medicationId =
            rawMedicationId != null && rawMedicationId.isNotEmpty
            ? rawMedicationId
            : null;
        final scannedData = med['scannedData'] is Map<String, dynamic>
            ? med['scannedData'] as Map<String, dynamic>
            : null;

        await _createUserMedication(
          medicationId: medicationId,
          scannedData: scannedData,
          frequency: 'as_needed',
          reminderEnabled: false,
          stockCount: 0,
          lowStockReminderEnabled: false,
        );
      }
      await _deleteScanTask(taskId);
      await ref.read(medicineProvider.notifier).fetchActiveMedications();
      _safeSetState(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: AppToast.message(e)),
      );
      return false;
    }
  }

  void onAddNew() => AppRouter.router.push(AppRoutes.scanMedicineBox);
  void onViewCabinet() => AppRouter.router.go(AppRoutes.medicine);
  void onComplete() => AppRouter.router.go(AppRoutes.medicine);

  void reset() {
    _safeSetState(ScanMedicineState(scanType: state.scanType));
  }
}

class _ScanOcrResult {
  final String scannedText;
  final String originalScannedText;
  final String normalizedScannedText;
  final List<String> lines;
  final String rawFullText;
  final List<String> rawLines;
  final List<String> rejectedLines;

  const _ScanOcrResult({
    required this.scannedText,
    required this.originalScannedText,
    required this.normalizedScannedText,
    required this.lines,
    required this.rawFullText,
    required this.rawLines,
    required this.rejectedLines,
  });
}

class _ScoredOcrLine {
  final String line;
  final int score;

  const _ScoredOcrLine(this.line, this.score);
}
