import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/routing/app_routes.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../../../core/config/routing/app_router.dart';

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

  SettingsNotifier(SettingsRepository _, this._getUserProfile, this.ref)
    : super(const SettingsState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _getUserProfile();
      if (!mounted) return;
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void onBack() {
    AppRouter.router.go(AppRoutes.home);
  }
}
