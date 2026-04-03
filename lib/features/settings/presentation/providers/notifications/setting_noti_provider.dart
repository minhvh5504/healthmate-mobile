import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_provider.dart';
import 'setting_noti_notifier.dart';

final settingNotiProvider =
    StateNotifierProvider<SettingNotiNotifier, SettingNotiState>(
  (ref) {
    return SettingNotiNotifier(
      ref.read(getNotificationSettingsUseCaseProvider),
      ref.read(updateNotificationTimeUseCaseProvider),
    );
  },
);
