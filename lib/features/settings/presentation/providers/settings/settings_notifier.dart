import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../../../core/config/routing/app_router.dart';

/// STATE
class SettingsState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// NOTIFIER
class SettingsNotifier extends StateNotifier<SettingsState> {
  final GetUserProfile _getUserProfile;
  final Ref ref;

  SettingsNotifier(this._getUserProfile, this.ref)
    : super(const SettingsState()) {
    loadProfile();
  }

  /// Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _getUserProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.home);
  }

  /// Handle Basic Info
  void onBasicInfo() {
    AppRouter.router.go(AppRoutes.profile);
  }

  /// Handle Family Connect
  void onFamilyConnect() {
    AppRouter.router.push(AppRoutes.familyConnection);
  }

  /// Handle Notifications
  void onNotifications() {
    AppRouter.router.go(AppRoutes.notificationSettings);
  }

  /// Handle Advanced
  void onAdvanced() {
    AppRouter.router.go(AppRoutes.highSettings);
  }

  /// Handle Support
  void onSupport() {
    // AppRouter.router.go('/settings/support');
  }

  /// Handle Edit avatar
  void onEditAvatar() {}
}
