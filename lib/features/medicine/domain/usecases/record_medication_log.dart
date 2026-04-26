import '../repositories/medication_repository.dart';

class RecordMedicationLog {
  final MedicationRepository repository;

  RecordMedicationLog(this.repository);

  Future<void> call({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
  }) {
    return repository.createMedicationLog(
      userMedicationId: userMedicationId,
      reminderScheduleId: reminderScheduleId,
      status: status,
      actualQuantity: actualQuantity,
      actualAt: actualAt,
    );
  }
}
