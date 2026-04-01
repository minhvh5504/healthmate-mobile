import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/routing/app_router.dart';
import '../../../../core/config/routing/app_routes.dart';

/// STATE
class HomeState {
  final bool isLoading;
  final String? errorMessage;

  const HomeState({this.isLoading = false, this.errorMessage});

  HomeState copyWith({bool? isLoading, String? errorMessage}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// NOTIFIER
class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(const HomeState());

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
