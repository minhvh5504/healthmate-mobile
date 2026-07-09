enum HealthMetricType {
  weight('weight'),
  height('height');

  final String value;
  const HealthMetricType(this.value);
}

enum HealthHistoryPeriodType {
  day('day'),
  week('week'),
  month('month');

  final String value;
  const HealthHistoryPeriodType(this.value);
}

class HealthHistoryPoint {
  final int index;
  final String label;
  final double value;
  final DateTime recordedAt;
  final int count;

  const HealthHistoryPoint({
    required this.index,
    required this.label,
    required this.value,
    required this.recordedAt,
    required this.count,
  });
}

class HealthHistory {
  final HealthMetricType metric;
  final HealthHistoryPeriodType period;
  final String unit;
  final double? currentValue;
  final double? averageValue;
  final DateTime startDate;
  final DateTime endDate;
  final List<HealthHistoryPoint> points;

  const HealthHistory({
    required this.metric,
    required this.period,
    required this.unit,
    required this.currentValue,
    required this.averageValue,
    required this.startDate,
    required this.endDate,
    required this.points,
  });
}
