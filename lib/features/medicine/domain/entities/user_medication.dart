import 'medication.dart';

class UserMedication {
  final String id;
  final String? medicationId;
  final Medication? medication;
  final bool isActive;
  final String? dosage;
  final Map<String, dynamic>? scannedData;

  const UserMedication({
    required this.id,
    this.medicationId,
    this.medication,
    required this.isActive,
    this.dosage,
    this.scannedData,
  });
}
