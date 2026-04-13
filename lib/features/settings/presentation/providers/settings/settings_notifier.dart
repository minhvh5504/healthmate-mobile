import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_routes.dart';

import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/providers/user_provider.dart';

class SettingsState {
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// NOTIFIER
class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref)
    : super(const SettingsState()) {
    ref.read(userProfileProvider.notifier).fetchProfile();
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
