import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';

class HealthHistoryChange {
  final String id;
  final HealthMetricType metric;
  final String unit;
  final double value;
  final double? previousValue;
  final double? change;
  final String direction;
  final double? bmi;
  final String? bmiStatus;
  final DateTime recordedAt;

  const HealthHistoryChange({
    required this.id,
    required this.metric,
    required this.unit,
    required this.value,
    required this.previousValue,
    required this.change,
    required this.direction,
    required this.bmi,
    required this.bmiStatus,
    required this.recordedAt,
  });
}

class HealthHistoryChanges {
  final HealthMetricType metric;
  final String unit;
  final List<HealthHistoryChange> changes;

  const HealthHistoryChanges({
    required this.metric,
    required this.unit,
    required this.changes,
  });
}
