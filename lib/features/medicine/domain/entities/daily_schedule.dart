import 'daily_schedule_item.dart';

class DailySchedule {
  final List<DailyScheduleItem> morning;
  final List<DailyScheduleItem> afternoon;
  final List<DailyScheduleItem> evening;

  const DailySchedule({
    required this.morning,
    required this.afternoon,
    required this.evening,
  });
}
