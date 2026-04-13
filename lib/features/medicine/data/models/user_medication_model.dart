import '../../domain/entities/user_medication.dart';
import 'medication_model.dart';

class UserMedicationModel extends UserMedication {
  const UserMedicationModel({
    required super.id,
    super.medicationId,
    super.medication,
    required super.isActive,
    super.dosage,
    super.scannedData,
  });

  factory UserMedicationModel.fromJson(Map<String, dynamic> json) {
    return UserMedicationModel(
      id: json['id']?.toString() ?? '',
      medicationId: json['medicationId']?.toString(),
      medication: json['medication'] != null
          ? MedicationModel.fromJson(json['medication'])
          : null,
      isActive: json['isActive'] ?? false,
      dosage: json['dosage']?.toString(),
      scannedData: json['scannedData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicationId': medicationId,
        'isActive': isActive,
        'dosage': dosage,
        'scannedData': scannedData,
      };
}
