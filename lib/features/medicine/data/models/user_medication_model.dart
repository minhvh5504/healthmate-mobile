import '../../domain/entities/user_medication.dart';
import 'medication_model.dart';
import 'medication_condition_model.dart';

class UserMedicationModel extends UserMedication {
  const UserMedicationModel({
    required super.id,
    super.medicationId,
    super.medication,
    super.condition,
    required super.isActive,
    super.dosage,
    super.mealInstruction,
    super.conditionId,
    super.conditionCustom,
    super.scannedData,
    super.stockCount,
    super.lowStockThreshold = 5,
    super.reminderEnabled = true,
    super.lowStockReminderEnabled = true,
    super.startDate,
    super.endDate,
    super.frequency,
    super.schedules,
    super.reminderSchedules,
    super.quantity,
  });

  factory UserMedicationModel.fromJson(Map<String, dynamic> json) {
    final reminderSchedules = json['reminderSchedules'] as List<dynamic>?;
    String? frequency = json['frequency']?.toString();
    if (frequency == null && reminderSchedules != null && reminderSchedules.isNotEmpty) {
      final first = reminderSchedules.first;
      if (first is Map) {
        frequency = first['repeatType']?.toString() ?? first['repeat_type']?.toString();
      }
    }

    return UserMedicationModel(
      id: json['id']?.toString() ?? '',
      medicationId: json['medicationId']?.toString(),
      medication: json['medication'] != null
          ? MedicationModel.fromJson(json['medication'])
          : null,
      condition: json['condition'] != null
          ? MedicationConditionModel.fromJson(json['condition'])
          : null,
      isActive: json['isActive'] ?? false,
      dosage: json['dosage']?.toString(),
      mealInstruction: json['mealInstruction']?.toString(),
      conditionId: json['conditionId']?.toString(),
      conditionCustom: json['conditionCustom']?.toString(),
      scannedData: json['scannedData'] as Map<String, dynamic>?,
      stockCount: json['stockCount'] as int?,
      lowStockThreshold: json['lowStockThreshold'] as int? ?? 5,
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      lowStockReminderEnabled: json['lowStockReminderEnabled'] as bool? ?? true,
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      frequency: frequency,
      schedules: json['schedules'] as List<dynamic>?,
      reminderSchedules: reminderSchedules,
      quantity: json['quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'isActive': isActive,
    'condition': condition,
    'dosage': dosage,
    'mealInstruction': mealInstruction,
    'conditionId': conditionId,
    'conditionCustom': conditionCustom,
    'scannedData': scannedData,
    'stockCount': stockCount,
    'lowStockThreshold': lowStockThreshold,
    'reminderEnabled': reminderEnabled,
    'lowStockReminderEnabled': lowStockReminderEnabled,
    'startDate': startDate,
    'endDate': endDate,
    'frequency': frequency,
    'schedules': schedules,
    'reminderSchedules': reminderSchedules,
    'quantity': quantity,
  };
}
