import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../settings/settings_provider.dart';

/// STATE
class HighSettingsState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;
  final String locale;

  const HighSettingsState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
    this.locale = 'vi',
  });

  HighSettingsState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
    String? locale,
  }) {
    return HighSettingsState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      locale: locale ?? this.locale,
    );
  }
}

/// NOTIFIER
class HighSettingsNotifier extends StateNotifier<HighSettingsState> {
  final Ref ref;

  HighSettingsNotifier(this.ref) : super(const HighSettingsState()) {
    loadProfile();
  }

  /// Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final getUserProfile = ref.read(getUserProfileUseCaseProvider);
      final profile = await getUserProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.settings);
  }

  /// Handle Language
  void onLanguage() {
    // Implement language change logic
  }

  /// Handle Change Password
  void onChangePassword() {
    // Navigate to change password page
  }

  /// Handle Logout
  Future<void> onLogout() async {
    // Implement logout logic
  }
}
