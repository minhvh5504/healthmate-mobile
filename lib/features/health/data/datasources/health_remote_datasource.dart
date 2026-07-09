import 'package:healthmate_mobile/features/health/data/api/health_api.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';

class HealthRemoteDataSource {
  final HealthApi _api;

  HealthRemoteDataSource(this._api);

  Future<UserProfile> getProfile() {
    return _api.getProfile();
  }

  Future<UserProfile> updateProfile(UserProfile profile) {
    final data = {
      if (profile.fullName != null) 'fullName': profile.fullName,
      if (profile.dateOfBirth != null)
        'dateOfBirth': profile.dateOfBirth!.toUtc().toIso8601String(),
      if (profile.gender != null) 'gender': profile.gender?.toLowerCase(),
      if (profile.heightCm != null) 'heightCm': profile.heightCm,
      if (profile.weightKg != null) 'weightKg': profile.weightKg,
      if (profile.allergies != null) 'allergies': profile.allergies,
    };
    return _api.updateProfile(data);
  }

  Future<HealthAnalysis> getHealthAnalysis() {
    return _api.getHealthAnalysis();
  }

  Future<HealthHistory> getHealthHistory({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return _api.getHealthHistory(
      metric.value,
      period.value,
      date != null ? _formatDate(date) : null,
    );
  }

  Future<HealthHistoryChanges> getHealthHistoryChanges({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return _api.getHealthHistoryChanges(
      metric.value,
      period.value,
      date != null ? _formatDate(date) : null,
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
