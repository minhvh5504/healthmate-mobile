import '../entities/medication.dart';
import '../entities/user_medication.dart';
import '../entities/scan_task.dart';
import '../entities/medication_condition.dart';
import '../entities/daily_schedule.dart';
import '../entities/family_member.dart';

abstract class MedicationRepository {
  Future<List<Medication>> searchMedications(String query);
  Future<ScanTask> scan({
    String? scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
    String? imagePath,
  });

  Future<List<ScanTask>> getScanTasks();
  Future<void> deleteScanTask(String id);

  Future<void> createUserMedication({
    String? medicationId,
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

  Future<void> deleteUserMedication(String id);

  Future<List<UserMedication>> getUserMedications();
  Future<List<MedicationCondition>> getMedicationConditions();

  Future<DailySchedule> getDailySchedule(String date);

  Future<void> createMedicationLog({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
    String? mealInstruction,
  });

  Future<void> updateMedicationLog({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
    String? mealInstruction,
  });

  Future<List<FamilyMember>> getUserRelationships();
}
