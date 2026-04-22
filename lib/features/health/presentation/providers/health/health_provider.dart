import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/network/api_client.dart';
import 'package:healthmate_mobile/features/health/data/api/health_api.dart';
import 'package:healthmate_mobile/features/health/data/datasources/health_remote_datasource.dart';
import 'package:healthmate_mobile/features/health/data/repositories/health_repository_impl.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/update_user_profile.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_notifier.dart';

export 'health_notifier.dart';

/// Retrofit API
final healthApiProvider = Provider<HealthApi>((ref) {
  return ApiClient(ref).create(HealthApi.new);
});

/// DataSource
final healthRemoteDataSourceProvider = Provider<HealthRemoteDataSource>((ref) {
  return HealthRemoteDataSource(ref.read(healthApiProvider));
});

/// Repository
final healthRepositoryProvider = Provider<HealthRepositoryImpl>((ref) {
  return HealthRepositoryImpl(
    remoteDataSource: ref.read(healthRemoteDataSourceProvider),
  );
});

/// UseCase get user profile
final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  return GetUserProfile(ref.read(healthRepositoryProvider));
});

/// UseCase update user profile
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  return UpdateUserProfile(ref.read(healthRepositoryProvider));
});

/// Notifier
final healthProvider = StateNotifierProvider<HealthNotifier, HealthState>((
  ref,
) {
  return HealthNotifier(
    ref.read(getUserProfileUseCaseProvider),
    ref.read(updateUserProfileUseCaseProvider),
  );
});
