import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationEntity>> call({
    bool? isRead,
    String? type,
    String? search,
    int? limit,
    int? page,
  }) {
    return repository.getNotifications(
      isRead: isRead,
      type: type,
      search: search,
      limit: limit,
      page: page,
    );
  }
}
