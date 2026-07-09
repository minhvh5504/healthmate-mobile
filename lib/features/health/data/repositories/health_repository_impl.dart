import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';
import 'package:healthmate_mobile/features/health/data/datasources/health_remote_datasource.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;

  HealthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return remoteDataSource.updateProfile(profile);
  }

  @override
  Future<HealthAnalysis> getHealthAnalysis() {
    return remoteDataSource.getHealthAnalysis();
  }

  @override
  Future<HealthHistory> getHealthHistory({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return remoteDataSource.getHealthHistory(
      metric: metric,
      period: period,
      date: date,
    );
  }

  @override
  Future<HealthHistoryChanges> getHealthHistoryChanges({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return remoteDataSource.getHealthHistoryChanges(
      metric: metric,
      period: period,
      date: date,
    );
  }
}
