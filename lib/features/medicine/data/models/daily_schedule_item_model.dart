import '../../domain/entities/daily_schedule_item.dart';

class DailyScheduleItemModel extends DailyScheduleItem {
  const DailyScheduleItemModel({
    required super.userMedicationId,
    required super.reminderScheduleId,
    required super.medicationName,
    super.dosage,
    super.remindTime,
    super.mealInstruction,
    required super.status,
    super.logId,
    super.takenAt,
  });

  factory DailyScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return DailyScheduleItemModel(
      userMedicationId: json['userMedicationId']?.toString() ?? '',
      reminderScheduleId: json['reminderScheduleId']?.toString() ?? '',
      medicationName: json['medicationName']?.toString() ?? '',
      dosage: json['dosage']?.toString(),
      remindTime: json['remindTime']?.toString(),
      mealInstruction: json['mealInstruction']?.toString(),
      status: json['status']?.toString() ?? 'PENDING',
      logId: json['logId']?.toString(),
      takenAt: json['takenAt'] != null ? DateTime.parse(json['takenAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'userMedicationId': userMedicationId,
        'reminderScheduleId': reminderScheduleId,
        'medicationName': medicationName,
        'dosage': dosage,
        'remindTime': remindTime,
        'mealInstruction': mealInstruction,
        'status': status,
        'logId': logId,
        'takenAt': takenAt?.toIso8601String(),
      };
}
