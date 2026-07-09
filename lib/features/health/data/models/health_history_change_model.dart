import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';

class HealthHistoryChangeModel extends HealthHistoryChange {
  const HealthHistoryChangeModel({
    required super.id,
    required super.metric,
    required super.unit,
    required super.value,
    required super.previousValue,
    required super.change,
    required super.direction,
    required super.bmi,
    required super.bmiStatus,
    required super.recordedAt,
  });

  factory HealthHistoryChangeModel.fromJson(Map<String, dynamic> json) {
    return HealthHistoryChangeModel(
      id: json['id']?.toString() ?? '',
      metric: _parseMetric(json['metric']),
      unit: json['unit']?.toString() ?? '',
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0,
      previousValue: double.tryParse(json['previousValue']?.toString() ?? ''),
      change: double.tryParse(json['change']?.toString() ?? ''),
      direction: json['direction']?.toString() ?? 'initial',
      bmi: double.tryParse(json['bmi']?.toString() ?? ''),
      bmiStatus: json['bmiStatus']?.toString(),
      recordedAt: _parseLocalDateTime(json['recordedAt']),
    );
  }

  static HealthMetricType _parseMetric(Object? value) {
    return HealthMetricType.values.firstWhere(
      (metric) => metric.value == value?.toString(),
      orElse: () => HealthMetricType.weight,
    );
  }
}

DateTime _parseLocalDateTime(Object? value) {
  return (DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now())
      .toLocal();
}

class HealthHistoryChangesModel extends HealthHistoryChanges {
  const HealthHistoryChangesModel({
    required super.metric,
    required super.unit,
    required super.changes,
  });

  factory HealthHistoryChangesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawChanges = data['changes'] is List
        ? data['changes'] as List
        : const [];

    return HealthHistoryChangesModel(
      metric: HealthHistoryChangeModel._parseMetric(data['metric']),
      unit: data['unit']?.toString() ?? '',
      changes: rawChanges
          .whereType<Map<String, dynamic>>()
          .map(HealthHistoryChangeModel.fromJson)
          .toList(),
    );
  }
}
