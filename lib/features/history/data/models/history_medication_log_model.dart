import 'package:healthmate_mobile/features/medicine/data/models/user_medication_model.dart';

import '../../domain/entities/history_medication_log.dart';

class HistoryMedicationLogModel extends HistoryMedicationLog {
  const HistoryMedicationLogModel({
    required super.id,
    required super.userMedicationId,
    super.reminderScheduleId,
    super.notificationId,
    required super.status,
    super.actualAt,
    required super.createdAt,
    super.userMedication,
    super.reminderSchedule,
    super.actualQuantity,
  });

  factory HistoryMedicationLogModel.fromJson(Map<String, dynamic> json) {
    return HistoryMedicationLogModel(
      id: json['id'] as String,
      userMedicationId: json['userMedicationId'] as String,
      reminderScheduleId: json['reminderScheduleId'] as String?,
      notificationId: json['notificationId'] as String?,
      status: json['status'] as String,
      actualAt: json['actualAt'] != null
          ? DateTime.parse(json['actualAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userMedication: json['userMedication'] != null
          ? UserMedicationModel.fromJson(
              json['userMedication'] as Map<String, dynamic>,
            )
          : null,
      reminderSchedule: json['reminderSchedule'] as Map<String, dynamic>?,
      actualQuantity: json['actualQuantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userMedicationId': userMedicationId,
      'reminderScheduleId': reminderScheduleId,
      'notificationId': notificationId,
      'status': status,
      'actualAt': actualAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'reminderSchedule': reminderSchedule,
      'actualQuantity': actualQuantity,
    };
  }
}
