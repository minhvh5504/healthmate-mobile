import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';

class GetUserProfile {
  final SettingsRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> call() {
    return repository.getProfile();
  }
}
