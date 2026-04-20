import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_reminder_edit_notifier.dart';

final medicineReminderEditProvider =
    StateNotifierProvider<
      MedicineReminderEditNotifier,
      MedicineReminderEditState
    >((ref) {
      return MedicineReminderEditNotifier(
        ref,
        ref.read(updateUserMedicationUseCaseProvider),
      );
    });
