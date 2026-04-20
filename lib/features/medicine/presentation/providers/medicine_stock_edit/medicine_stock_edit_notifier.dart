import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../medicine/medicine_provider.dart';

class MedicineStockEditState {
  final Map<String, dynamic> medication;
  final int stockCount;
  final int lowStockThreshold;
  final bool lowStockReminderEnabled;
  final bool isLoading;

  MedicineStockEditState({
    this.medication = const {},
    this.stockCount = 30,
    this.lowStockThreshold = 5,
    this.lowStockReminderEnabled = true,
    this.isLoading = false,
  });

  MedicineStockEditState copyWith({
    Map<String, dynamic>? medication,
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
    bool? isLoading,
  }) {
    return MedicineStockEditState(
      medication: medication ?? this.medication,
      stockCount: stockCount ?? this.stockCount,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      lowStockReminderEnabled:
          lowStockReminderEnabled ?? this.lowStockReminderEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MedicineStockEditNotifier extends StateNotifier<MedicineStockEditState> {
  final Ref ref;
  final UpdateUserMedication _updateUserMedication;

  MedicineStockEditNotifier(this.ref, this._updateUserMedication)
    : super(MedicineStockEditState());

  void init(Map<String, dynamic> medication) {
    state = state.copyWith(
      medication: medication,
      stockCount: medication['stockCount'] as int? ?? 0,
      lowStockThreshold: medication['lowStockThreshold'] as int? ?? 5,
      lowStockReminderEnabled:
          medication['lowStockReminderEnabled'] as bool? ?? true,
    );
  }

  void updateStockCount(int count) {
    state = state.copyWith(stockCount: count);
  }

  void updateLowStockThreshold(int threshold) {
    state = state.copyWith(lowStockThreshold: threshold);
  }

  void toggleLowStockReminder(bool value) {
    state = state.copyWith(lowStockReminderEnabled: value);
  }

  Future<void> onSave() async {
    state = state.copyWith(isLoading: true);
    try {
      final id = state.medication['id'];
      if (id != null) {
        await _updateUserMedication(
          id: id,
          stockCount: state.stockCount,
          lowStockThreshold: state.lowStockThreshold,
          lowStockReminderEnabled: state.lowStockReminderEnabled,
        );
        await ref.read(medicineProvider.notifier).fetchActiveMedications();
      }
      AppRouter.router.pop();
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
