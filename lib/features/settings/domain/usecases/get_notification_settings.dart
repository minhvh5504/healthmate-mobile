import '../entities/notification_time.dart';
import '../repositories/settings_repository.dart';

class GetNotificationSettings {
  final SettingsRepository repository;

  GetNotificationSettings(this.repository);

  Future<List<NotificationTime>> call() {
    return repository.getNotificationSettings();
  }
}
