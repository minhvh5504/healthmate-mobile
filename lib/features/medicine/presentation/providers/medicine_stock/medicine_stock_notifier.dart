import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../medicine_flow/medicine_flow_provider.dart';

class MedicineStockState {
  final Map<String, dynamic> medication;
  final int stockCount;
  final int lowStockThreshold;
  final bool lowStockReminderEnabled;
  final bool isLoading;

  MedicineStockState({
    this.medication = const {},
    this.stockCount = 30,
    this.lowStockThreshold = 5,
    this.lowStockReminderEnabled = true,
    this.isLoading = false,
  });

  MedicineStockState copyWith({
    Map<String, dynamic>? medication,
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
    bool? isLoading,
  }) {
    return MedicineStockState(
      medication: medication ?? this.medication,
      stockCount: stockCount ?? this.stockCount,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      lowStockReminderEnabled:
          lowStockReminderEnabled ?? this.lowStockReminderEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MedicineStockNotifier extends StateNotifier<MedicineStockState> {
  final Ref ref;

  MedicineStockNotifier(this.ref) : super(MedicineStockState());

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
    ref
        .read(medicineFlowProvider.notifier)
        .updateStock(
          stockCount: state.stockCount,
          lowStockThreshold: state.lowStockThreshold,
          lowStockReminderEnabled: state.lowStockReminderEnabled,
        );

    await AppRouter.router.push(AppRoutes.medicineReview);
  }
}
