import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';

class AddMedicineState {
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  AddMedicineState({
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  AddMedicineState copyWith({
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddMedicineState(
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AddMedicineNotifier extends StateNotifier<AddMedicineState> {
  final Ref ref;

  AddMedicineNotifier(this.ref) : super(AddMedicineState());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void onScanPrescription() {
    // Implement prescription scan logic
  }

  void onScanMedicineBox() {
    // Implement medicine box scan logic
  }

  void onClose() {
    AppRouter.router.go(AppRoutes.medicine);
  }
}
