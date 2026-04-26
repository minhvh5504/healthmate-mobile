import '../repositories/medication_repository.dart';

class UpdateMedicationLog {
  final MedicationRepository repository;

  UpdateMedicationLog(this.repository);

  Future<void> call({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
  }) {
    return repository.updateMedicationLog(
      id: id,
      status: status,
      actualQuantity: actualQuantity,
      actualAt: actualAt,
    );
  }
}
