import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/routing/app_router.dart';
import '../../../../core/config/routing/app_routes.dart';
import '../../../settings/domain/entities/user_profile.dart';
import '../../../settings/presentation/providers/settings/settings_provider.dart';

/// STATE
class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final UserProfile? profile;

  const HomeState({this.isLoading = false, this.errorMessage, this.profile});

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserProfile? profile,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      profile: profile ?? this.profile,
    );
  }
}

/// NOTIFIER
class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(const HomeState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final useCase = ref.read(getUserProfileUseCaseProvider);
      final profile = await useCase();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle ai assistant
  void onAiAssistant() {
    // AppRouter.router.go(AppRoutes.ai);
  }

  /// Handle connect relative
  void onConnectRelative() {
    // AppRouter.router.go(AppRoutes.health);
  }

  /// Handle update health
  void onUpdateHealth() {
    AppRouter.router.go(AppRoutes.health);
  }

  /// Handle profile
  void onProfile() {
    AppRouter.router.go(AppRoutes.settings);
  }

  /// Handle notification click
  void onNotification() {
    AppRouter.router.push(AppRoutes.notifications);
  }
}
