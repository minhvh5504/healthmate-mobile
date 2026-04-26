import '../entities/history_medication_log.dart';

abstract class HistoryRepository {
  Future<List<HistoryMedicationLog>> getMedicationLogs({
    String? userMedicationId,
    String? range,
    String? date,
  });
}
