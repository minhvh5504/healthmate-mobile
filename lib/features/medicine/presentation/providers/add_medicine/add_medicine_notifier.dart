import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/medication.dart';
import '../medication_provider.dart';

/// State
class AddMedicineState {
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  final List<Medication> searchResults;
  final bool isSearchMode;

  AddMedicineState({
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
    this.searchResults = const [],
    this.isSearchMode = false,
  });

  AddMedicineState copyWith({
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    List<Medication>? searchResults,
    bool? isSearchMode,
  }) {
    return AddMedicineState(
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchResults: searchResults ?? this.searchResults,
      isSearchMode: isSearchMode ?? this.isSearchMode,
    );
  }
}

/// Notifier
class AddMedicineNotifier extends StateNotifier<AddMedicineState> {
  final Ref ref;
  Timer? _debounce;

  AddMedicineNotifier(this.ref) : super(AddMedicineState());

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Handle update search query
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

    _debounce = Timer(const Duration(seconds: 1), () {
      state = state.copyWith(searchQuery: query, isSearchMode: true);
      searchMedications(query);
    });
  }

  /// Handle cancel search
  void cancelSearch() {
    _debounce?.cancel();
    state = state.copyWith(
      isSearchMode: false,
      searchQuery: '',
      searchResults: [],
      isLoading: false,
    );
  }

  /// Handle search medications
  Future<void> searchMedications(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final results = await ref
          .read(medicationRepositoryProvider)
          .searchMedications(query);
      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle scan prescription
  void onScanPrescription() {
    // Implement prescription scan logic
  }

  /// Handle scan medicine box
  void onScanMedicineBox() {
    // Implement medicine box scan logic
  }

  /// Handle close
  void onClose() {
    AppRouter.router.go(AppRoutes.medicine);
  }

  /// Handle select medication
  void onSelectMedication(Medication medication) {
    // Handle medication selection, e.g., navigate to detail or add to schedule
  }
}
