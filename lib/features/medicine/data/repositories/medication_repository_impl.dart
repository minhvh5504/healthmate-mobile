import '../../domain/entities/medication.dart';
import '../../domain/entities/user_medication.dart';
import '../../domain/entities/scan_task.dart';
import '../../domain/entities/medication_condition.dart';
import '../../domain/entities/daily_schedule.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_datasource.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;

  MedicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Medication>> searchMedications(String query) {
    return remoteDataSource.searchMedications(query);
  }

  @override
  Future<ScanTask> scan({
    required String scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
  }) {
    return remoteDataSource.scan(
      scannedText: scannedText,
      shape: shape,
      rawData: rawData,
    );
  }

  @override
  Future<List<ScanTask>> getScanTasks() {
    return remoteDataSource.getScanTasks();
  }

  @override
  Future<void> deleteScanTask(String id) {
    return remoteDataSource.deleteScanTask(id);
  }

  @override
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
  }) {
    return remoteDataSource.createUserMedication(
      medicationId: medicationId,
      scannedData: scannedData,
      data: {
        if (frequency != null) 'frequency': frequency,
        if (selectedDays != null) 'selectedDays': selectedDays,
        if (schedules != null) 'schedules': schedules,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (reminderEnabled != null) 'reminderEnabled': reminderEnabled,
        if (stockCount != null) 'stockCount': stockCount,
        if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
        if (lowStockReminderEnabled != null)
          'lowStockReminderEnabled': lowStockReminderEnabled,
        if (conditionId != null) 'conditionId': conditionId,
        if (conditionCustom != null) 'conditionCustom': conditionCustom,
      },
    );
  }

  @override
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
  }) {
    return remoteDataSource.updateUserMedication(
      id: id,
      data: {
        if (isActive != null) 'isActive': isActive,
        if (dosage != null) 'dosage': dosage,
        if (mealInstruction != null) 'mealInstruction': mealInstruction,
        if (mealInstructionNote != null)
          'mealInstructionNote': mealInstructionNote,
        if (conditionId != null) 'conditionId': conditionId,
        if (conditionCustom != null) 'conditionCustom': conditionCustom,
        if (frequency != null) 'frequency': frequency,
        if (selectedDays != null) 'selectedDays': selectedDays,
        if (schedules != null) 'schedules': schedules,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (reminderEnabled != null) 'reminderEnabled': reminderEnabled,
        if (stockCount != null) 'stockCount': stockCount,
        if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
        if (lowStockReminderEnabled != null)
          'lowStockReminderEnabled': lowStockReminderEnabled,
        if (medicationId != null) 'medicationId': medicationId,
        if (scannedData != null) 'scannedData': scannedData,
      },
    );
  }

  @override
  Future<List<UserMedication>> getUserMedications() {
    return remoteDataSource.getUserMedications();
  }

  @override
  Future<List<MedicationCondition>> getMedicationConditions() {
    return remoteDataSource.getMedicationConditions();
  }

  @override
  Future<DailySchedule> getDailySchedule(String date) {
    return remoteDataSource.getDailySchedule(date);
  }

  @override
  Future<void> createMedicationLog({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
  }) {
    return remoteDataSource.createMedicationLog(
      userMedicationId: userMedicationId,
      reminderScheduleId: reminderScheduleId,
      status: status,
      actualQuantity: actualQuantity,
      actualAt: actualAt,
    );
  }

  @override
  Future<void> updateMedicationLog({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
  }) {
    return remoteDataSource.updateMedicationLog(
      id: id,
      status: status,
      actualQuantity: actualQuantity,
      actualAt: actualAt,
    );
  }
}
