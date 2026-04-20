import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_stock_edit_notifier.dart';

final medicineStockEditProvider =
    StateNotifierProvider<
      MedicineStockEditNotifier,
      MedicineStockEditState
    >((ref) {
      return MedicineStockEditNotifier(
        ref,
        ref.read(updateUserMedicationUseCaseProvider),
      );
    });
