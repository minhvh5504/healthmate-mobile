import '../../domain/entities/scan_task.dart';
import '../../domain/entities/user_medication.dart';
import 'user_medication_model.dart';

class ScanTaskModel extends ScanTask {
  const ScanTaskModel({
    required super.id,
    required super.createdAt,
    required super.status,
    super.errorMessage,
    super.imagePath,
    super.userMedications,
  });

  factory ScanTaskModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status']?.toString() ?? 'PENDING';
    ScanStatus status = ScanStatus.processing;
    if (statusStr == 'SUCCESS') {
      status = ScanStatus.success;
    } else if (statusStr == 'FAILED') {
      status = ScanStatus.failed;
    }

    final rawScannedData = _normalizeRawScannedData(json);

    final userMedications = _parseUserMedications(json, rawScannedData);

    return ScanTaskModel(
      id: json['id']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: status,
      userMedications: userMedications,
      imagePath:
          json['imageUrl']?.toString() ??
          json['imagePath']?.toString() ??
          rawScannedData?['imageUrl']?.toString() ??
          rawScannedData?['imagePath']?.toString(),
    );
  }

  static List<UserMedication>? _parseUserMedications(
    Map<String, dynamic> json,
    Map<String, dynamic>? rawScannedData,
  ) {
    final rawList = json['userMedications'] ?? json['medications'];
    if (rawList is List) {
      return rawList
          .whereType<Map>()
          .map(
            (item) => UserMedicationModel.fromJson({
              ...item.cast<String, dynamic>(),
              'isActive': item['isActive'] ?? false,
            }),
          )
          .toList();
    }

    if (json['medication'] != null) {
      return [
        UserMedicationModel.fromJson({
          'id': json['id'],
          'medicationId': json['medicationId'],
          'medication': json['medication'],
          'isActive': false,
          'scannedData': rawScannedData,
        }),
      ];
    }

    return null;
  }

  static Map<String, dynamic>? _normalizeRawScannedData(
    Map<String, dynamic> json,
  ) {
    final raw = json['rawScannedData'] ?? json['scannedData'];
    final normalized = <String, dynamic>{};

    if (raw is Map) {
      raw.forEach((key, value) {
        if (key != null) normalized[key.toString()] = value;
      });
    } else if (raw != null) {
      normalized['raw'] = raw.toString();
    }

    final scannedText =
        json['scannedText'] ?? json['recognizedText'] ?? json['text'];
    if (scannedText != null &&
        (normalized['scannedText']?.toString().isNotEmpty != true)) {
      normalized['scannedText'] = scannedText.toString();
    }

    final lines = json['lines'];
    if (lines != null && normalized['lines'] == null) {
      normalized['lines'] = lines;
    }

    return normalized.isEmpty ? null : normalized;
  }
}
