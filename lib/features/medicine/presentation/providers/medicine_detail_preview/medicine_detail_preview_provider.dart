import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_detail_preview_notifier.dart';

final getMedicationConditionsUseCaseProvider =
    Provider<GetMedicationConditions>((ref) {
      return GetMedicationConditions(ref.read(medicationRepositoryProvider));
    });

final medicineDetailPreviewProvider =
    StateNotifierProvider<
      MedicineDetailPreviewNotifier,
      MedicineDetailPreviewState
    >((ref) => MedicineDetailPreviewNotifier(ref: ref));
