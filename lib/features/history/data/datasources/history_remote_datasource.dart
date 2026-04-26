import '../api/history_api.dart';
import '../models/history_medication_log_model.dart';
import '../../domain/entities/history_medication_log.dart';

class HistoryRemoteDataSource {
  final HistoryApi _api;

  HistoryRemoteDataSource(this._api);

  Future<List<HistoryMedicationLog>> getMedicationLogs({
    String? userMedicationId,
    String? range,
    String? date,
  }) async {
    final response = await _api.getMedicationLogs(
      userMedicationId: userMedicationId,
      range: range,
      date: date,
    );
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data.map((json) => HistoryMedicationLogModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
