import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/get_notification_settings.dart';
import '../settings/settings_provider.dart';
import 'setting_noti_notifier.dart';

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettings>((ref) {
      return GetNotificationSettings(ref.read(settingsRepositoryProvider));
    });

final settingNotiProvider =
    StateNotifierProvider<SettingNotiNotifier, SettingNotiState>((ref) {
      return SettingNotiNotifier(
        ref.read(getNotificationSettingsUseCaseProvider),
      );
    });
