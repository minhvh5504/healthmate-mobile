import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/realtime_provider.dart';

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

  HomeNotifier(this.ref) : super(const HomeState()) {
    ref.read(userProfileProvider.notifier).fetchProfile();
    _registerDeviceToken();
  }

  /// Register FCM device token
  void _registerDeviceToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        ref.read(deviceTokenServiceProvider).registerToken(token);
      }
    });
  }

  /// Handle ai assistant
  void onAiAssistant() {
    AppRouter.router.push(AppRoutes.chat);
  }

  /// Handle connect relative
  void onConnectRelative() {
    AppRouter.router.push(AppRoutes.familyConnection);
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
