import '../repositories/notification_repository.dart';

class DeleteAllNotifications {
  final NotificationRepository repository;

  DeleteAllNotifications(this.repository);

  Future<void> call() {
    return repository.deleteAll();
  }
}
