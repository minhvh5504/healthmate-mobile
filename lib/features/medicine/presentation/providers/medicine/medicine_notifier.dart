import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../settings/domain/entities/user_profile.dart';
import '../../../../settings/presentation/providers/settings/settings_provider.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';

enum MedicineTab { schedule, cabinet }

/// State
class MedicineState {
  final MedicineTab selectedTab;
  final DateTime selectedDate;
  final bool isLoading;
  final String? errorMessage;
  final UserProfile? profile;

  MedicineState({
    this.selectedTab = MedicineTab.schedule,
    DateTime? selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.profile,
  }) : selectedDate = selectedDate ?? DateTime.now();

  /// Returns a copy with the provided fields overridden.
  MedicineState copyWith({
    MedicineTab? selectedTab,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    UserProfile? profile,
  }) {
    return MedicineState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
    );
  }
}

/// Notifier
class MedicineNotifier extends StateNotifier<MedicineState> {
  final Ref ref;

  MedicineNotifier(this.ref) : super(MedicineState()) {
    loadProfile();
  }

  /// Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final useCase = ref.read(getUserProfileUseCaseProvider);
      final profile = await useCase();
      if (!mounted) return;
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Switch tab
  void selectTab(MedicineTab tab) {
    state = state.copyWith(selectedTab: tab, errorMessage: null);
  }

  /// Select date
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, errorMessage: null);
  }

  /// Add medicine
  void onAddMedicine() {
    AppRouter.router.go(AppRoutes.addMedicine);
  }
}
