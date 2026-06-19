import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../prescription/prescription_provider.dart';

class PrescriptionDetailsState {
  final Prescription? prescription;
  final List<Prescription> historyPrescriptions;
  final bool isLoading;

  const PrescriptionDetailsState({
    this.prescription,
    this.historyPrescriptions = const [],
    this.isLoading = false,
  });

  PrescriptionDetailsState copyWith({
    Prescription? prescription,
    List<Prescription>? historyPrescriptions,
    bool? isLoading,
  }) {
    return PrescriptionDetailsState(
      prescription: prescription ?? this.prescription,
      historyPrescriptions: historyPrescriptions ?? this.historyPrescriptions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PrescriptionDetailsNotifier
    extends StateNotifier<PrescriptionDetailsState> {
  PrescriptionDetailsNotifier(this._ref, Prescription? initialPrescription)
    : super(const PrescriptionDetailsState()) {
    _syncFromPrescriptionState(
      initialPrescription,
      _ref.read(prescriptionProvider),
    );
    _ref.listen<PrescriptionState>(prescriptionProvider, (previous, next) {
      _syncFromPrescriptionState(
        state.prescription ?? initialPrescription,
        next,
      );
    });
  }

  final Ref _ref;

  void _syncFromPrescriptionState(
    Prescription? preferredPrescription,
    PrescriptionState prescriptionState,
  ) {
    final id = preferredPrescription?.id;
    final selected = id == null
        ? null
        : prescriptionState.activePrescriptions.firstWhere(
            (item) => item.id == id,
            orElse: () => prescriptionState.historyPrescriptions.firstWhere(
              (item) => item.id == id,
              orElse: () => preferredPrescription!,
            ),
          );

    state = PrescriptionDetailsState(
      prescription: selected,
      historyPrescriptions: prescriptionState.historyPrescriptions,
      isLoading: prescriptionState.isLoading && prescriptionState.isInitialLoad,
    );
  }

  /// Go back.
  void handleGoBack() => AppRouter.router.pop();

  /// Go to edit prescription
  Future<void> handleGoToEdit(Prescription prescription) async {
    final result = await AppRouter.router.push<bool>(
      AppRoutes.editPrescription,
      extra: prescription,
    );
    if (result == true) {
      await _ref.read(prescriptionProvider.notifier).fetchPrescriptions();
    }
  }

  /// Delete prescription and go back.
  Future<void> handleDelete(String id) async {
    await _ref.read(prescriptionProvider.notifier).deletePrescription(id);
    AppRouter.router.pop();
  }
}
