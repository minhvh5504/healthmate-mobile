import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/notification_time.dart';
import '../../../domain/usecases/get_notification_settings.dart';

/// STATE
class SettingNotiState {
  final bool isNotificationsEnabled;
  final bool isSoundEnabled;
  final List<NotificationTime> notificationTimes;
  final bool isLoading;

  const SettingNotiState({
    this.isNotificationsEnabled = true,
    this.isSoundEnabled = true,
    this.notificationTimes = const [],
    this.isLoading = false,
  });

  SettingNotiState copyWith({
    bool? isNotificationsEnabled,
    bool? isSoundEnabled,
    List<NotificationTime>? notificationTimes,
    bool? isLoading,
  }) {
    return SettingNotiState(
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      notificationTimes: notificationTimes ?? this.notificationTimes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// NOTIFIER
class SettingNotiNotifier extends StateNotifier<SettingNotiState> {
  final GetNotificationSettings _getNotificationSettings;

  SettingNotiNotifier(this._getNotificationSettings)
    : super(const SettingNotiState()) {
    _loadSettings();
  }

  /// Load notification
  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true);
    try {
      final settings = await _getNotificationSettings();
      state = state.copyWith(notificationTimes: settings, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.settings);
  }

  /// Toggle notifications
  void toggleNotifications(bool value) {
    state = state.copyWith(isNotificationsEnabled: value);
  }

  /// Toggle sound
  void toggleSound(bool value) {
    state = state.copyWith(isSoundEnabled: value);
  }
}
