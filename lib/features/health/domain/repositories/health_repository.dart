import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';

abstract class HealthRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<HealthAnalysis> getHealthAnalysis();
  Future<HealthHistory> getHealthHistory({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  });
  Future<HealthHistoryChanges> getHealthHistoryChanges({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  });
}
