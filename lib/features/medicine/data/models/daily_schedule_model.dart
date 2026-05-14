import '../../domain/entities/daily_schedule.dart';
import 'daily_schedule_item_model.dart';

class DailyScheduleModel extends DailySchedule {
  const DailyScheduleModel({
    required super.morning,
    required super.afternoon,
    required super.evening,
  });

  factory DailyScheduleModel.fromJson(Map<String, dynamic> json) {
    return DailyScheduleModel(
      morning:
          (json['morning'] as List<dynamic>?)
              ?.map(
                (item) => DailyScheduleItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      afternoon:
          (json['afternoon'] as List<dynamic>?)
              ?.map(
                (item) => DailyScheduleItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      evening:
          (json['evening'] as List<dynamic>?)
              ?.map(
                (item) => DailyScheduleItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'morning': (morning as List<DailyScheduleItemModel>)
        .map((item) => item.toJson())
        .toList(),
    'afternoon': (afternoon as List<DailyScheduleItemModel>)
        .map((item) => item.toJson())
        .toList(),
    'evening': (evening as List<DailyScheduleItemModel>)
        .map((item) => item.toJson())
        .toList(),
  };
}
