import 'medication.dart';
import 'medication_condition.dart';

class UserMedication {
  final String id;
  final String? medicationId;
  final Medication? medication;
  final MedicationCondition? condition;
  final bool isActive;
  final String? dosage;
  final String? mealInstruction;
  final String? conditionId;
  final String? conditionCustom;
  final Map<String, dynamic>? scannedData;
  final int? stockCount;
  final int lowStockThreshold;
  final bool reminderEnabled;
  final bool lowStockReminderEnabled;
  final String? startDate;
  final String? endDate;
  final String? frequency;
  final List<dynamic>? schedules;
  final List<dynamic>? reminderSchedules;
  final int? quantity;

  const UserMedication({
    required this.id,
    this.medicationId,
    this.medication,
    this.condition,
    required this.isActive,
    this.dosage,
    this.mealInstruction,
    this.conditionId,
    this.conditionCustom,
    this.scannedData,
    this.stockCount,
    this.lowStockThreshold = 5,
    this.reminderEnabled = true,
    this.lowStockReminderEnabled = true,
    this.startDate,
    this.endDate,
    this.frequency,
    this.schedules,
    this.reminderSchedules,
    this.quantity,
  });

  String get effectiveName =>
      scannedData?['customName']?.toString() ??
      medication?.name ??
      _firstScannedTextLine ??
      '-';

  String? get _firstScannedTextLine {
    final lines = scannedData?['lines'];
    if (lines is List) {
      for (final line in lines) {
        final value = line?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    final scannedText =
        scannedData?['scannedText']?.toString() ??
        scannedData?['raw']?.toString();
    if (scannedText == null) return null;

    for (final line in scannedText.split('\n')) {
      final value = line.trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  String get effectiveManufacturer =>
      scannedData?['customManufacturer']?.toString() ??
      medication?.manufacturer ??
      '-';

  UserMedication copyWith({
    String? id,
    String? medicationId,
    Medication? medication,
    MedicationCondition? condition,
    bool? isActive,
    String? dosage,
    String? mealInstruction,
    String? conditionId,
    String? conditionCustom,
    Map<String, dynamic>? scannedData,
    int? stockCount,
    int? lowStockThreshold,
    bool? reminderEnabled,
    bool? lowStockReminderEnabled,
    String? startDate,
    String? endDate,
    String? frequency,
    List<dynamic>? schedules,
    List<dynamic>? reminderSchedules,
    int? quantity,
  }) {
    return UserMedication(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medication: medication ?? this.medication,
      condition: condition ?? this.condition,
      isActive: isActive ?? this.isActive,
      dosage: dosage ?? this.dosage,
      mealInstruction: mealInstruction ?? this.mealInstruction,
      conditionId: conditionId ?? this.conditionId,
      conditionCustom: conditionCustom ?? this.conditionCustom,
      scannedData: scannedData ?? this.scannedData,
      stockCount: stockCount ?? this.stockCount,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      lowStockReminderEnabled:
          lowStockReminderEnabled ?? this.lowStockReminderEnabled,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      schedules: schedules ?? this.schedules,
      reminderSchedules: reminderSchedules ?? this.reminderSchedules,
      quantity: quantity ?? this.quantity,
    );
  }
}
