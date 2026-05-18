import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/realtime_provider.dart';
import '../../../auth/presentation/providers/auth/auth_notifier.dart';
import '../../../auth/presentation/providers/auth/auth_provider.dart';
import '../../../medicine/domain/entities/daily_schedule.dart';
import '../../../medicine/domain/usecases/get_daily_schedule.dart';

/// STATE
class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final DailySchedule? dailySchedule;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.dailySchedule,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    DailySchedule? dailySchedule,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      dailySchedule: dailySchedule ?? this.dailySchedule,
    );
  }
}

/// NOTIFIER
class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  final GetDailyScheduleUseCase _getDailySchedule;

  HomeNotifier(this.ref, this._getDailySchedule) : super(const HomeState()) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn && next.accessToken != null) {
        if (previous?.isLoggedIn != true) {
          ref.read(userProfileProvider.notifier).fetchProfile();
          fetchTodaySchedule();
          _registerDeviceToken();
        }
      }
    });

    final auth = ref.read(authProvider);
    if (auth.isLoggedIn && auth.accessToken != null) {
      ref.read(userProfileProvider.notifier).fetchProfile();
      fetchTodaySchedule();
      _registerDeviceToken();
    }
  }

  /// Register FCM device token
  void _registerDeviceToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        ref.read(deviceTokenServiceProvider).registerToken(token);
      }
    });
  }

  Future<void> fetchTodaySchedule() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final schedule = await _getDailySchedule(today);

      if (!mounted) return;
      state = state.copyWith(dailySchedule: schedule, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
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

  /// Handle medicine list
  void onMedicine() {
    AppRouter.router.go(AppRoutes.medicine);
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
