import '../../../medicine/domain/entities/user_medication.dart';

class HistoryMedicationLog {
  final String id;
  final String userMedicationId;
  final String? reminderScheduleId;
  final String? notificationId;
  final String status;
  final DateTime? actualAt;
  final DateTime createdAt;
  final String? loggedMealInstruction;
  final UserMedication? userMedication;
  final Map<String, dynamic>? reminderSchedule;
  final int? actualQuantity;

  const HistoryMedicationLog({
    required this.id,
    required this.userMedicationId,
    this.reminderScheduleId,
    this.notificationId,
    required this.status,
    this.actualAt,
    required this.createdAt,
    this.loggedMealInstruction,
    this.userMedication,
    this.reminderSchedule,
    this.actualQuantity,
  });

  bool get isTaken => status.toLowerCase() == 'taken';
  bool get isMissed => status.toLowerCase() == 'missed';

  String? get remindTime => reminderSchedule?['remindTime']?.toString();
  String? get medicationName => userMedication?.effectiveName;

  String? get dosage =>
      reminderSchedule?['dosage']?.toString() ?? userMedication?.dosage;

  String? get mealInstruction {
    final loggedSlug = loggedMealInstruction;
    if (loggedSlug != null && loggedSlug.isNotEmpty) return loggedSlug;

    final slug = userMedication?.mealInstruction;
    if (slug != null && slug.isNotEmpty) return slug;

    // Fallback logic to match backend's daily schedule mapping
    final time = remindTime;
    if (time == null || time.isEmpty) return null;

    try {
      final parts = time.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final minutes = h * 60 + m;

      if (minutes <= 8 * 60) return 'before_breakfast';
      if (minutes <= 10 * 60) return 'after_breakfast';
      if (minutes <= 11 * 60 + 30) return 'between_meals';
      if (minutes <= 12 * 60 + 30) return 'before_lunch';
      if (minutes <= 14 * 60) return 'after_lunch';
      if (minutes <= 17 * 60 + 30) return 'between_meals';
      if (minutes <= 18 * 60 + 30) return 'before_dinner';
      if (minutes <= 20 * 60) return 'after_dinner';
      return 'before_sleep';
    } catch (_) {
      return null;
    }
  }
}
