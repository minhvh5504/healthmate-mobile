import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';

abstract class HealthRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<HealthAnalysis> getHealthAnalysis();
}
