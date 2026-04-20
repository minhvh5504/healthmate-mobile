import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_detail_preview_edit_notifier.dart';

final getMedicationConditionsUseCaseProvider =
    Provider<GetMedicationConditions>((ref) {
      return GetMedicationConditions(ref.read(medicationRepositoryProvider));
    });

final medicineDetailPreviewEditProvider =
    StateNotifierProvider<
      MedicineDetailPreviewEditNotifier,
      MedicineDetailPreviewEditState
    >((ref) {
      return MedicineDetailPreviewEditNotifier(
        ref,
        ref.read(updateUserMedicationUseCaseProvider),
        ref.read(getMedicationConditionsUseCaseProvider),
      );
    });
