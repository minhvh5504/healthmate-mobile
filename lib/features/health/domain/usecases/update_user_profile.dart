import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';

class UpdateUserProfile {
  final HealthRepository repository;

  UpdateUserProfile(this.repository);

  Future<UserProfile> call(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
