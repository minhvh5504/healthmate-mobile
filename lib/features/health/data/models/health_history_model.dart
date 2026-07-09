import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';

class HealthHistoryPointModel extends HealthHistoryPoint {
  const HealthHistoryPointModel({
    required super.index,
    required super.label,
    required super.value,
    required super.recordedAt,
    required super.count,
  });

  factory HealthHistoryPointModel.fromJson(Map<String, dynamic> json) {
    return HealthHistoryPointModel(
      index: int.tryParse(json['index']?.toString() ?? '') ?? 0,
      label: json['label']?.toString() ?? '',
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0,
      recordedAt: _parseLocalDateTime(json['recordedAt']),
      count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
    );
  }
}

DateTime _parseLocalDateTime(Object? value) {
  return (DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now())
      .toLocal();
}

class HealthHistoryModel extends HealthHistory {
  const HealthHistoryModel({
    required super.metric,
    required super.period,
    required super.unit,
    required super.currentValue,
    required super.averageValue,
    required super.startDate,
    required super.endDate,
    required super.points,
  });

  factory HealthHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawPoints = data['points'] is List
        ? data['points'] as List
        : const [];

    return HealthHistoryModel(
      metric: _parseMetric(data['metric']),
      period: _parsePeriod(data['period']),
      unit: data['unit']?.toString() ?? '',
      currentValue: double.tryParse(data['currentValue']?.toString() ?? ''),
      averageValue: double.tryParse(data['averageValue']?.toString() ?? ''),
      startDate: _parseLocalDateTime(data['startDate']),
      endDate: _parseLocalDateTime(data['endDate']),
      points: rawPoints
          .whereType<Map<String, dynamic>>()
          .map(HealthHistoryPointModel.fromJson)
          .toList(),
    );
  }

  static HealthMetricType _parseMetric(Object? value) {
    return HealthMetricType.values.firstWhere(
      (metric) => metric.value == value?.toString(),
      orElse: () => HealthMetricType.weight,
    );
  }

  static HealthHistoryPeriodType _parsePeriod(Object? value) {
    return HealthHistoryPeriodType.values.firstWhere(
      (period) => period.value == value?.toString(),
      orElse: () => HealthHistoryPeriodType.day,
    );
  }
}
