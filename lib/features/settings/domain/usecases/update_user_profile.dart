import '../entities/user_profile.dart';
import '../repositories/settings_repository.dart';

class UpdateUserProfile {
  final SettingsRepository repository;

  UpdateUserProfile(this.repository);

  Future<UserProfile> call(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
