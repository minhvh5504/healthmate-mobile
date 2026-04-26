import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/history_api.dart';
import '../../../data/datasources/history_remote_datasource.dart';
import '../../../data/repositories/history_repository_impl.dart';
import '../../../domain/repositories/history_repository.dart';
import '../../../domain/usecases/get_history_logs.dart';
import 'history_notifier.dart';

export 'history_notifier.dart';

/// API Provider
final historyApiProvider = Provider<HistoryApi>((ref) {
  return ApiClient(ref).create(HistoryApi.new);
});

/// DataSource Provider
final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>(
  (ref) {
    return HistoryRemoteDataSource(ref.read(historyApiProvider));
  },
);

/// Repository Provider
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(
    remoteDataSource: ref.read(historyRemoteDataSourceProvider),
  );
});

/// UseCase Provider
final getHistoryLogsProvider = Provider<GetHistoryLogs>((ref) {
  return GetHistoryLogs(ref.read(historyRepositoryProvider));
});

/// StateNotifier Provider
final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(
    ref,
    ref.read(getHistoryLogsProvider),
  ),
);
