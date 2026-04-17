import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../domain/entities/medication.dart';
import '../../../domain/entities/medication_condition.dart';
import '../add_medicine/add_medicine_provider.dart';
import 'medicine_detail_preview_provider.dart';

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

  Timer? _debounce;

  MedicineDetailPreviewNotifier({required this.ref})
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
    /// Navigate to the next screen (e.g., schedule setup)
    /// Pass state.medication data down
    /// AppRouter.router.push(AppRoutes.nextScreen, extra: state.medication);
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

    state = state.copyWith(medication: updatedMedication);
  }

  Future<void> fetchMedicationConditions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final getConditionsUseCase = ref.read(
        getMedicationConditionsUseCaseProvider,
      );
      final results = await getConditionsUseCase();
      state = state.copyWith(medicationConditions: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
