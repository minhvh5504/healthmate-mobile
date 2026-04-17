import '../repositories/medication_repository.dart';

class UpdateUserMedication {
  final MedicationRepository repository;
  UpdateUserMedication(this.repository);

  Future<void> call({
    required String id,
    bool? isActive,
    String? dosage,
    int? stockCount,
  }) {
    return repository.updateUserMedication(
      id: id,
      isActive: isActive,
      dosage: dosage,
      stockCount: stockCount,
    );
  }
}
