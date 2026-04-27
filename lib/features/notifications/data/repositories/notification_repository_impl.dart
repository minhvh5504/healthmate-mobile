import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications({
    bool? isRead,
    String? type,
    String? search,
    int? limit,
    int? page,
  }) {
    return remoteDataSource.getNotifications(
      isRead: isRead,
      type: type,
      search: search,
      limit: limit,
      page: page,
    );
  }

  @override
  Future<void> markReadById(String id) {
    return remoteDataSource.markReadById(id);
  }

  @override
  Future<void> markReadAll() {
    return remoteDataSource.markReadAll();
  }

  @override
  Future<void> deleteById(String id) {
    return remoteDataSource.deleteById(id);
  }

  @override
  Future<void> deleteAll() {
    return remoteDataSource.deleteAll();
  }
}
