import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/medication.dart';
import '../../../domain/entities/medication_condition.dart';
import '../../../domain/usecases/get_medication_conditions.dart';
import '../add_medicine/add_medicine_provider.dart';
import '../medicine_flow/medicine_flow_provider.dart';

/// State
class MedicineDetailPreviewState {
  final Map<String, dynamic> medication;
  final bool isLoading;
  final String? errorMessage;

  final List<Medication> searchResults;
  final String searchQuery;
  final bool isSearchMode;
  final List<MedicationCondition> medicationConditions;

  MedicineDetailPreviewState({
    this.medication = const {},
    this.isLoading = false,
    this.errorMessage,
    this.searchResults = const [],
    this.searchQuery = '',
    this.isSearchMode = false,
    this.medicationConditions = const [],
  });

  MedicineDetailPreviewState copyWith({
    Map<String, dynamic>? medication,
    bool? isLoading,
    String? errorMessage,
    List<Medication>? searchResults,
    String? searchQuery,
    bool? isSearchMode,
    List<MedicationCondition>? medicationConditions,
  }) {
    return MedicineDetailPreviewState(
      medication: medication ?? this.medication,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      medicationConditions: medicationConditions ?? this.medicationConditions,
    );
  }

  String get name => medication['name'] ?? '-';
  String get manufacturer => medication['manufacturer'] ?? '-';
  String get genericName => medication['genericName'] ?? '-';
  String get strength => medication['strength'] ?? '-';
  String? get medicationId => medication['medicationId'];
}

/// Notifier
class MedicineDetailPreviewNotifier
    extends StateNotifier<MedicineDetailPreviewState> {
  final Ref ref;
  final GetMedicationConditions _getMedicationConditions;

  Timer? _debounce;

  MedicineDetailPreviewNotifier(this.ref, this._getMedicationConditions)
    : super(MedicineDetailPreviewState());

  void init(Map<String, dynamic> medication) {
    state = state.copyWith(medication: medication);
    fetchMedicationConditions();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void onContinue() {
    ref
        .read(medicineFlowProvider.notifier)
        .updateMedicineInfo(
          name: state.name,
          manufacturer: state.manufacturer,
          genericName: state.genericName,
          strength: state.strength,
          medicationId: state.medicationId,
        );

    AppRouter.router.push(AppRoutes.medicineReminder);
  }

  void onBack() {
    AppRouter.router.pop();
  }

  void onEditName() {
    state = state.copyWith(isSearchMode: true, searchQuery: state.name);
    if (state.name.isNotEmpty && state.name != '-') {
      searchMedications(state.name);
    }
  }

  void updateSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        searchResults: [],
        isLoading: false,
      );
      return;
    }

    /// Update searchQuery immediately for the "Custom medicine" option UI
    state = state.copyWith(searchQuery: query);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMedications(query);
    });
  }

  Future<void> searchMedications(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final searchUseCase = ref.read(searchMedicationsUseCaseProvider);
      final results = await searchUseCase(query);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void onSelectMedication(Medication medication) {
    final updatedMedication = Map<String, dynamic>.from(state.medication);
    updatedMedication['name'] = medication.name;
    updatedMedication['manufacturer'] = medication.manufacturer;
    updatedMedication['genericName'] = medication.genericName;
    updatedMedication['strength'] = medication.strength;
    updatedMedication['medicationId'] = medication.id;

    state = state.copyWith(
      medication: updatedMedication,
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
    );

    ref
        .read(medicineFlowProvider.notifier)
        .updateMedicineInfo(
          name: medication.name,
          manufacturer: medication.manufacturer,
          genericName: medication.genericName,
          strength: medication.strength,
          medicationId: medication.id,
        );
  }

  void onCustomMedicine(String name) {
    final updatedMedication = Map<String, dynamic>.from(state.medication);
    updatedMedication['name'] = name;
    updatedMedication['medicationId'] = null;

    state = state.copyWith(
      medication: updatedMedication,
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
    );

    ref
        .read(medicineFlowProvider.notifier)
        .updateMedicineInfo(name: name, medicationId: null);
  }

  void cancelSearch() {
    _debounce?.cancel();
    state = state.copyWith(
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
      isLoading: false,
    );
  }

  void updateField(String field, dynamic value) {
    final updatedMedication = Map<String, dynamic>.from(state.medication);
    updatedMedication[field] = value;

    state = state.copyWith(medication: updatedMedication);

    ref
        .read(medicineFlowProvider.notifier)
        .updateMedicineInfo(
          name: updatedMedication['name'],
          manufacturer: updatedMedication['manufacturer'],
          genericName: updatedMedication['genericName'],
          strength: updatedMedication['strength'],
          medicationId: updatedMedication['medicationId'],
        );
  }

  void updateCondition(String? id, String? custom, String label) {
    final updatedMedication = Map<String, dynamic>.from(state.medication);
    updatedMedication['conditionId'] = id;
    updatedMedication['conditionCustom'] = custom;
    updatedMedication['genericName'] = label; // For UI display

    state = state.copyWith(medication: updatedMedication);

    ref
        .read(medicineFlowProvider.notifier)
        .updateCondition(
          conditionId: id,
          conditionCustom: custom,
          genericName: label,
        );
  }

  Future<void> fetchMedicationConditions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final conditions = await _getMedicationConditions();
      state = state.copyWith(
        medicationConditions: conditions,
        isLoading: false,
      );

      final conditionId = state.medication['conditionId'];
      final currentGenericName = state.medication['genericName'];

      if (conditionId != null &&
          (currentGenericName == null ||
              currentGenericName == '-' ||
              currentGenericName.isEmpty)) {
        final match = conditions.cast<MedicationCondition?>().firstWhere(
          (c) => c?.id == conditionId,
          orElse: () => null,
        );
        if (match != null) {
          final label = 'medicine.condition.${match.slug}'.tr();
          final updatedMedication = Map<String, dynamic>.from(state.medication);
          updatedMedication['genericName'] = label;
          state = state.copyWith(medication: updatedMedication);
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
