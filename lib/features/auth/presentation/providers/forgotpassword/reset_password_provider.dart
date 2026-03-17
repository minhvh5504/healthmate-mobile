import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/reset_password.dart';
import 'reset_password_notifier.dart';

/// Retrofit Api With Dio
final authApiProvider = Provider<AuthApi>((ref) {
  return ApiClient(ref).create(AuthApi.new);
});

/// DataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.read(authApiProvider));
});

/// Repository
final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  ),
);

/// UseCase
final resetPasswordUseCaseProvider = Provider<ResetPassword>(
  (ref) => ResetPassword(ref.read(authRepositoryProvider)),
);

/// Notifier
final resetPasswordNotifierProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      (ref) =>
          ResetPasswordNotifier(ref.read(resetPasswordUseCaseProvider), ref),
    );
