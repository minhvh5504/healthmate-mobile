import '../entities/history_medication_log.dart';
import '../repositories/history_repository.dart';

class GetHistoryLogs {
  final HistoryRepository repository;

  GetHistoryLogs(this.repository);

  Future<List<HistoryMedicationLog>> call({
    String? userMedicationId,
    String? range,
    String? date,
  }) {
    return repository.getMedicationLogs(
      userMedicationId: userMedicationId,
      range: range,
      date: date,
    );
  }
}
