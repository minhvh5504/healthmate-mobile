import '../repositories/settings_repository.dart';

class ChangePassword {
  final SettingsRepository repository;

  ChangePassword(this.repository);

  Future<void> call(String currentPassword, String newPassword) {
    return repository.changePassword(currentPassword, newPassword);
  }
}
