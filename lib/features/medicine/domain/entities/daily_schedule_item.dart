class DailyScheduleItem {
  final String userMedicationId;
  final String reminderScheduleId;
  final String medicationName;
  final String? dosage;
  final String? remindTime;
  final String? mealInstruction;
  final String status;
  final String? logId;
  final DateTime? takenAt;

  const DailyScheduleItem({
    required this.userMedicationId,
    required this.reminderScheduleId,
    required this.medicationName,
    this.dosage,
    this.remindTime,
    this.mealInstruction,
    required this.status,
    this.logId,
    this.takenAt,
  });
}
