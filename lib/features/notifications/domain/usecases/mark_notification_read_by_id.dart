import '../repositories/notification_repository.dart';

class MarkNotificationReadById {
  final NotificationRepository repository;

  MarkNotificationReadById(this.repository);

  Future<void> call(String id) {
    return repository.markReadById(id);
  }
}
