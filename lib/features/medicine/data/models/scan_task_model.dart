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

    // Map medication to a UserMedication if it exists
    List<UserMedication>? userMedications;
    if (json['medication'] != null) {
      userMedications = [
        UserMedicationModel.fromJson({
          'id': json['id'], // Use task ID or create a dummy? 
          'medicationId': json['medicationId'],
          'medication': json['medication'],
          'isActive': false,
          'scannedData': json['rawScannedData'],
        })
      ];
    } else {
       // Even if failed, we can preserve the scanned data in a dummy entry
       userMedications = [
         UserMedicationModel(
           id: json['id'],
           medicationId: null,
           medication: null,
           isActive: false,
           scannedData: json['rawScannedData'] is Map<String, dynamic> 
              ? json['rawScannedData'] as Map<String, dynamic>
              : null,
         )
       ];
    }

    return ScanTaskModel(
      id: json['id']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      status: status,
      userMedications: userMedications,
      imagePath: (json['rawScannedData'] as Map?)?['imagePath']?.toString(), // If saved in raw data
    );
  }
}
