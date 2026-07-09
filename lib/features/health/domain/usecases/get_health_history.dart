import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';

class GetHealthHistory {
  final HealthRepository repository;

  GetHealthHistory(this.repository);

  Future<HealthHistory> call({
    required HealthMetricType metric,
    required HealthHistoryPeriodType period,
    DateTime? date,
  }) {
    return repository.getHealthHistory(
      metric: metric,
      period: period,
      date: date,
    );
  }
}
