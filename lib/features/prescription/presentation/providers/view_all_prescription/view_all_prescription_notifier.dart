import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../prescription/prescription_provider.dart';

class ViewAllPrescriptionState {
  final List<Prescription> historyPrescriptions;
  final bool isLoading;
  final String? errorMessage;

  const ViewAllPrescriptionState({
    this.historyPrescriptions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ViewAllPrescriptionState copyWith({
    List<Prescription>? historyPrescriptions,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ViewAllPrescriptionState(
      historyPrescriptions: historyPrescriptions ?? this.historyPrescriptions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}

class ViewAllPrescriptionNotifier
    extends StateNotifier<ViewAllPrescriptionState> {
  ViewAllPrescriptionNotifier(this._ref)
    : super(const ViewAllPrescriptionState()) {
    _syncFromPrescriptionState(_ref.read(prescriptionProvider));
    _ref.listen<PrescriptionState>(prescriptionProvider, (previous, next) {
      _syncFromPrescriptionState(next);
    });
  }

  final Ref _ref;

  void _syncFromPrescriptionState(PrescriptionState prescriptionState) {
    state = ViewAllPrescriptionState(
      historyPrescriptions: prescriptionState.historyPrescriptions,
      isLoading: prescriptionState.isLoading,
      errorMessage: prescriptionState.errorMessage,
    );
  }

  Future<void> fetchPrescriptions() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _ref.read(prescriptionProvider.notifier).fetchPrescriptions();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
      AppToast.error(e);
    }
  }

  /// Go back.
  void handleGoBack() => AppRouter.router.pop();

  /// Go to prescription details.
  void handleGoToDetails(Prescription prescription) {
    AppRouter.router.push(AppRoutes.prescriptionDetails, extra: prescription);
  }
}
