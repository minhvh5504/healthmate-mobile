import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/medication.dart';
import '../../../domain/entities/medication_condition.dart';
import '../add_medicine/add_medicine_provider.dart';
import '../medicine/medicine_provider.dart';

/// State
class MedicineDetailPreviewEditState {
  final Map<String, dynamic> medication;
  final bool isLoading;
  final String? errorMessage;

  final List<Medication> searchResults;
  final String searchQuery;
  final bool isSearchMode;
  final List<MedicationCondition> medicationConditions;

  MedicineDetailPreviewEditState({
    this.medication = const {},
    this.isLoading = false,
    this.errorMessage,
    this.searchResults = const [],
    this.searchQuery = '',
    this.isSearchMode = false,
    this.medicationConditions = const [],
  });

  MedicineDetailPreviewEditState copyWith({
    Map<String, dynamic>? medication,
    bool? isLoading,
    String? errorMessage,
    List<Medication>? searchResults,
    String? searchQuery,
    bool? isSearchMode,
    List<MedicationCondition>? medicationConditions,
  }) {
    return MedicineDetailPreviewEditState(
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
class MedicineDetailPreviewEditNotifier
    extends StateNotifier<MedicineDetailPreviewEditState> {
  final Ref ref;
  final UpdateUserMedication _updateUserMedication;
  final GetMedicationConditions _getMedicationConditions;

  Timer? _debounce;

  MedicineDetailPreviewEditNotifier(
    this.ref,
    this._updateUserMedication,
    this._getMedicationConditions,
  ) : super(MedicineDetailPreviewEditState());

  void init(Map<String, dynamic> medication) {
    final initialMedication = Map<String, dynamic>.from(medication);

    if (initialMedication['medication'] != null) {
      final med = initialMedication['medication'] as Map<String, dynamic>;
      initialMedication['name'] ??= med['name'];
      initialMedication['manufacturer'] ??= med['manufacturer'];
      initialMedication['genericName'] ??= med['genericName'];
      initialMedication['strength'] ??= med['strength'];
      initialMedication['medicationId'] ??= med['id'];
    }

    if (initialMedication['scannedData'] != null) {
      final scanned = initialMedication['scannedData'] as Map<String, dynamic>;
      if (scanned['customName'] != null) {
        initialMedication['name'] = scanned['customName'];
      }
      if (scanned['customManufacturer'] != null) {
        initialMedication['manufacturer'] = scanned['customManufacturer'];
      }
    }

    if (initialMedication['dosage'] == null ||
        initialMedication['dosage'] == '-') {
      initialMedication['dosage'] = initialMedication['strength'];
    }

    state = state.copyWith(medication: initialMedication);
    fetchMedicationConditions();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void onContinue() {
    AppRouter.router.push(AppRoutes.medicineReminder, extra: state.medication);
  }

  Future<void> onSave() async {
    final id = state.medication['id'];
    if (id == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final currentScannedData = Map<String, dynamic>.from(
        state.medication['scannedData'] ?? {},
      );
      currentScannedData['customName'] = state.medication['name'];
      currentScannedData['customManufacturer'] =
          state.medication['manufacturer'];

      await _updateUserMedication(
        id: id,
        medicationId: state.medicationId,
        dosage: state.medication['dosage'],
        mealInstruction: state.medication['mealInstruction'],
        mealInstructionNote: state.medication['mealInstructionNote'],
        conditionId: state.medication['conditionId'],
        conditionCustom: state.medication['conditionCustom'],
        scannedData: currentScannedData,
      );
      await ref.read(medicineProvider.notifier).fetchActiveMedications();
      AppRouter.router.pop(true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
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

    if (field == 'dosage') {
      updatedMedication['strength'] = value;
    } else if (field == 'strength') {
      updatedMedication['dosage'] = value;
    }

    state = state.copyWith(medication: updatedMedication);
  }

  void updateCondition(String? id, String? custom, String label) {
    final updatedMedication = Map<String, dynamic>.from(state.medication);
    updatedMedication['conditionId'] = id;
    updatedMedication['conditionCustom'] = custom;
    updatedMedication['genericName'] = label;
    state = state.copyWith(medication: updatedMedication);
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
