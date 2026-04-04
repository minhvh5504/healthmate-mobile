import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/settings_api.dart';
import '../../../data/datasources/settings_remote_datasource.dart';
import '../../../data/repositories/settings_repository_impl.dart';
import '../../../domain/usecases/get_notification_settings.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/update_notification_time.dart';
import 'settings_notifier.dart';

/// Retrofit API
final settingsApiProvider = Provider<SettingsApi>((ref) {
  return ApiClient(ref).create(SettingsApi.new);
});

/// DataSource
final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((
  ref,
) {
  return SettingsRemoteDataSource(ref.read(settingsApiProvider));
});

/// Repository
final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  return SettingsRepositoryImpl(
    remoteDataSource: ref.read(settingsRemoteDataSourceProvider),
  );
});

/// UseCase
final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  return GetUserProfile(ref.read(settingsRepositoryProvider));
});

final getNotificationSettingsUseCaseProvider =
    Provider<GetNotificationSettings>((ref) {
      return GetNotificationSettings(ref.read(settingsRepositoryProvider));
    });

final updateNotificationTimeUseCaseProvider = Provider<UpdateNotificationTime>((
  ref,
) {
  return UpdateNotificationTime(ref.read(settingsRepositoryProvider));
});

/// Notifier
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier(ref.read(getUserProfileUseCaseProvider), ref);
  },
);
