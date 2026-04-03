import '../repositories/settings_repository.dart';

class UpdateNotificationTime {
  final SettingsRepository repository;

  UpdateNotificationTime(this.repository);

  Future<void> call(String id, String newTime) {
    return repository.updateNotificationTime(id, newTime);
  }
}
