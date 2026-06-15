import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../domain/usecases/create_user_medication.dart';
import '../medicine/medicine_provider.dart';
import '../medicine_flow/medicine_flow_provider.dart';

class MedicineReviewState {
  final Map<String, dynamic> medication;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  MedicineReviewState({
    this.medication = const {},
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  bool get isAsNeeded => medication['frequency'] == 'as_needed';

  List<dynamic> get schedules => medication['schedules'] ?? [];

  String get unit => medication['unit'] ?? 'medicine.unit_default'.tr();

  String get timeInfo => !isAsNeeded && schedules.isNotEmpty
      ? '${schedules[0]['time']} • ${schedules[0]['quantity'] ?? schedules[0]['doses'] ?? 1} $unit'
      : '';

  MedicineReviewState copyWith({
    Map<String, dynamic>? medication,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return MedicineReviewState(
      medication: medication ?? this.medication,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class MedicineReviewNotifier extends StateNotifier<MedicineReviewState> {
  final Ref ref;
  final CreateUserMedication _createUserMedication;

  MedicineReviewNotifier(this.ref, this._createUserMedication)
    : super(MedicineReviewState());

  void init(Map<String, dynamic> medication) {
    state = state.copyWith(medication: medication);
  }

  Future<void> onSaveInfo() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _submitFlow();
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void onCancel() {
    ref.read(medicineFlowProvider.notifier).init({});
    AppRouter.router.go(AppRoutes.medicine);
  }

  Future<void> _submitFlow() async {
    final flow = ref.read(medicineFlowProvider);
    if (flow.medicationId == null) {
      throw Exception('Medication information is incomplete.');
    }

    final startDateStr = flow.startDate != null
        ? DateTime.utc(
            flow.startDate!.year,
            flow.startDate!.month,
            flow.startDate!.day,
          ).toIso8601String()
        : null;
    final isAsNeeded = flow.frequency == 'as_needed';
    final endDateStr = !isAsNeeded && flow.endDate != null
        ? DateTime.utc(
            flow.endDate!.year,
            flow.endDate!.month,
            flow.endDate!.day,
          ).toIso8601String()
        : null;

    await _createUserMedication(
      medicationId: flow.medicationId!,
      scannedData: flow.scannedData,
      frequency: flow.frequency,
      selectedDays: isAsNeeded ? null : flow.selectedDays,
      schedules: isAsNeeded ? null : flow.schedules,
      startDate: startDateStr,
      endDate: endDateStr,
      reminderEnabled: isAsNeeded ? false : flow.reminderEnabled,
      stockCount: flow.stockCount,
      lowStockThreshold: flow.lowStockThreshold,
      lowStockReminderEnabled: flow.lowStockReminderEnabled,
      conditionId: flow.conditionId,
      conditionCustom: flow.conditionCustom,
    );

    ref.read(medicineFlowProvider.notifier).init({});
    await ref.read(medicineProvider.notifier).fetchActiveMedications();
  }

  void onBack() {
    AppRouter.router.pop();
  }
}
