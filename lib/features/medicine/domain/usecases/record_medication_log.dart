import '../repositories/medication_repository.dart';

class RecordMedicationLog {
  final MedicationRepository repository;

  RecordMedicationLog(this.repository);

  Future<void> call({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    String? dosageTaken,
    String? note,
    DateTime? takenAt,
  }) {
    return repository.createMedicationLog(
      userMedicationId: userMedicationId,
      reminderScheduleId: reminderScheduleId,
      status: status,
      dosageTaken: dosageTaken,
      note: note,
      takenAt: takenAt,
    );
  }
}
