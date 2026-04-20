import '../repositories/medication_repository.dart';

class CreateUserMedication {
  final MedicationRepository repository;
  CreateUserMedication(this.repository);

  Future<void> call({
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
    return repository.createUserMedication(
      medicationId: medicationId,
      scannedData: scannedData,
      frequency: frequency,
      selectedDays: selectedDays,
      schedules: schedules,
      startDate: startDate,
      endDate: endDate,
      reminderEnabled: reminderEnabled,
      stockCount: stockCount,
      lowStockThreshold: lowStockThreshold,
      lowStockReminderEnabled: lowStockReminderEnabled,
      conditionId: conditionId,
      conditionCustom: conditionCustom,
    );
  }
}
