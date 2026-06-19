import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/prescription.dart';
import '../../../domain/usecases/get_prescriptions.dart';
import '../../../domain/usecases/delete_prescription.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/utils/app_toast.dart';

class PrescriptionState {
  final bool isLoading;
  final bool isInitialLoad;
  final List<Prescription> activePrescriptions;
  final List<Prescription> historyPrescriptions;
  final String? errorMessage;

  const PrescriptionState({
    this.isLoading = false,
    this.isInitialLoad = true,
    this.activePrescriptions = const [],
    this.historyPrescriptions = const [],
    this.errorMessage,
  });

  PrescriptionState copyWith({
    bool? isLoading,
    bool? isInitialLoad,
    List<Prescription>? activePrescriptions,
    List<Prescription>? historyPrescriptions,
    String? errorMessage,
  }) {
    return PrescriptionState(
      isLoading: isLoading ?? this.isLoading,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
      activePrescriptions: activePrescriptions ?? this.activePrescriptions,
      historyPrescriptions: historyPrescriptions ?? this.historyPrescriptions,
      errorMessage: errorMessage,
    );
  }
}

class PrescriptionNotifier extends StateNotifier<PrescriptionState> {
  final GetPrescriptions _getPrescriptions;
  final DeletePrescription _deletePrescription;

  PrescriptionNotifier(this._getPrescriptions, this._deletePrescription)
    : super(const PrescriptionState()) {
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    state = state.copyWith(isLoading: true);
    try {
      final all = await _getPrescriptions();
      state = state.copyWith(
        isLoading: false,
        isInitialLoad: false,
        activePrescriptions: all.where((p) => p.isActive).toList(),
        historyPrescriptions: all.where((p) => !p.isActive).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isInitialLoad: false,
        errorMessage: e.toString(),
      );
      AppToast.error(e);
    }
  }

  Future<void> deletePrescription(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _deletePrescription(id);
      await fetchPrescriptions();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      AppToast.error(e);
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Go to prescription list.
  void handleGoToPrescription() {
    AppRouter.router.push(AppRoutes.prescription);
  }

  /// Go to prescription details.
  void handleGoToDetails(Prescription prescription) {
    AppRouter.router.push(AppRoutes.prescriptionDetails, extra: prescription);
  }

  /// Go to add prescription
  Future<void> handleGoToAdd() async {
    final result = await AppRouter.router.push<bool>(AppRoutes.addPrescription);
    if (result == true) await fetchPrescriptions();
  }

  /// Go to edit prescription
  Future<void> handleGoToEdit(Prescription prescription) async {
    final result = await AppRouter.router.push<bool>(
      AppRoutes.editPrescription,
      extra: prescription,
    );
    if (result == true) await fetchPrescriptions();
  }

  /// Go to view all prescription history.
  void handleGoToViewAll() {
    AppRouter.router.push(AppRoutes.viewAllPrescription);
  }
}
