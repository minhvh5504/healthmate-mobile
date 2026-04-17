import 'medication.dart';

class UserMedication {
  final String id;
  final String? medicationId;
  final Medication? medication;
  final bool isActive;
  final String? dosage;
  final Map<String, dynamic>? scannedData;
  final int? stockCount;

  const UserMedication({
    required this.id,
    this.medicationId,
    this.medication,
    required this.isActive,
    this.dosage,
    this.scannedData,
    this.stockCount,
  });

  UserMedication copyWith({
    String? id,
    String? medicationId,
    Medication? medication,
    bool? isActive,
    String? dosage,
    Map<String, dynamic>? scannedData,
    int? stockCount,
  }) {
    return UserMedication(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medication: medication ?? this.medication,
      isActive: isActive ?? this.isActive,
      dosage: dosage ?? this.dosage,
      scannedData: scannedData ?? this.scannedData,
      stockCount: stockCount ?? this.stockCount,
    );
  }
}
