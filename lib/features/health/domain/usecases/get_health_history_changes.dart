import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';

class GetHealthHistoryChanges {
  final HealthRepository repository;

  GetHealthHistoryChanges(this.repository);

  Future<HealthHistoryChanges> call({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return repository.getHealthHistoryChanges(
      metric: metric,
      period: period,
      date: date,
    );
  }
}
