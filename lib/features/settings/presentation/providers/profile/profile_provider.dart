import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/settings_api.dart';
import '../../../data/datasources/settings_remote_datasource.dart';
import '../../../data/repositories/settings_repository_impl.dart';
import 'profile_notifier.dart';
import '../settings/settings_provider.dart'; // reuse getUserProfileUseCaseProvider
import '../../../domain/usecases/update_user_profile.dart';

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

/// UseCase update profile
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  return UpdateUserProfile(ref.read(settingsRepositoryProvider));
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(
    ref.read(getUserProfileUseCaseProvider),
    ref.read(updateUserProfileUseCaseProvider),
  );
});
