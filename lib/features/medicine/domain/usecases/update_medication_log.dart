import '../repositories/medication_repository.dart';

class UpdateMedicationLog {
  final MedicationRepository repository;

  UpdateMedicationLog(this.repository);

  Future<void> call({
    required String id,
    String? status,
    String? dosageTaken,
    String? note,
    DateTime? takenAt,
  }) {
    return repository.updateMedicationLog(
      id: id,
      status: status,
      dosageTaken: dosageTaken,
      note: note,
      takenAt: takenAt,
    );
  }
}
