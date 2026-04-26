import '../../domain/entities/history_medication_log.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HistoryMedicationLog>> getMedicationLogs({
    String? userMedicationId,
    String? range,
    String? date,
  }) {
    return remoteDataSource.getMedicationLogs(
      userMedicationId: userMedicationId,
      range: range,
      date: date,
    );
  }
}
