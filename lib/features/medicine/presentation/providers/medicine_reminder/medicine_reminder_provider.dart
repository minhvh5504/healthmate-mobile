import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_reminder_notifier.dart';

final updateUserMedicationUseCaseProvider = Provider<UpdateUserMedication>((
  ref,
) {
  return UpdateUserMedication(ref.read(medicationRepositoryProvider));
});

final medicineReminderProvider =
    StateNotifierProvider<MedicineReminderNotifier, MedicineReminderState>((
      ref,
    ) {
      return MedicineReminderNotifier(ref);
    });
