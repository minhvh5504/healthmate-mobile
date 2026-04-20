import '../entities/medication.dart';
import '../entities/user_medication.dart';
import '../entities/scan_task.dart';
import '../entities/medication_condition.dart';

abstract class MedicationRepository {
  Future<List<Medication>> searchMedications(String query);
  Future<ScanTask> scan({
    required String scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
  });

  Future<List<ScanTask>> getScanTasks();
  Future<void> deleteScanTask(String id);

  Future<void> createUserMedication({
    required String medicationId,
    Map<String, dynamic>? scannedData,
    String? frequency,
    List<int>? selectedDays,
    List<Map<String, dynamic>>? schedules,
    String? startDate,
    String? endDate,
    bool? reminderEnabled,
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
    String? conditionId,
    String? conditionCustom,
  });

  Future<void> updateUserMedication({
    required String id,
    bool? isActive,
    String? dosage,
    String? mealInstruction,
    String? mealInstructionNote,
    String? conditionId,
    String? conditionCustom,
    String? frequency,
    List<int>? selectedDays,
    List<Map<String, dynamic>>? schedules,
    String? startDate,
    String? endDate,
    bool? reminderEnabled,
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
    String? medicationId,
    Map<String, dynamic>? scannedData,
  });

  Future<List<UserMedication>> getUserMedications();
  Future<List<MedicationCondition>> getMedicationConditions();
}
