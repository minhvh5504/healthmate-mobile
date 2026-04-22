import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';

class GetUserProfile {
  final HealthRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> call() {
    return repository.getProfile();
  }
}
