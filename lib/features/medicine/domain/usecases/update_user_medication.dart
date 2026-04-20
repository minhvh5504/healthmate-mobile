import '../repositories/medication_repository.dart';

class UpdateUserMedication {
  final MedicationRepository repository;
  UpdateUserMedication(this.repository);

  Future<void> call({
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
    return repository.updateUserMedication(
      id: id,
      isActive: isActive,
      dosage: dosage,
      mealInstruction: mealInstruction,
      mealInstructionNote: mealInstructionNote,
      conditionId: conditionId,
      conditionCustom: conditionCustom,
      frequency: frequency,
      selectedDays: selectedDays,
      schedules: schedules,
      startDate: startDate,
      endDate: endDate,
      reminderEnabled: reminderEnabled,
      stockCount: stockCount,
      lowStockThreshold: lowStockThreshold,
      lowStockReminderEnabled: lowStockReminderEnabled,
      medicationId: medicationId,
      scannedData: scannedData,
    );
  }
}
