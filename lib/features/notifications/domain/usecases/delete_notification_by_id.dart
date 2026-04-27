import '../repositories/notification_repository.dart';

class DeleteNotificationById {
  final NotificationRepository repository;

  DeleteNotificationById(this.repository);

  Future<void> call(String id) {
    return repository.deleteById(id);
  }
}
