import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({
    bool? isRead,
    String? type,
    String? search,
    int? limit,
    int? page,
  });

  Future<void> markReadById(String id);

  Future<void> markReadAll();

  Future<void> deleteById(String id);

  Future<void> deleteAll();
}
