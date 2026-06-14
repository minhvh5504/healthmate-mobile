import '../repositories/medication_repository.dart';

class UpdateMedicationLog {
  final MedicationRepository repository;

  UpdateMedicationLog(this.repository);

  Future<void> call({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
    String? mealInstruction,
  }) {
    return repository.updateMedicationLog(
      id: id,
      status: status,
      actualQuantity: actualQuantity,
      actualAt: actualAt,
      mealInstruction: mealInstruction,
    );
  }
}
