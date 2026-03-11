import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/refresh_token_account.dart';
import 'auth_notifier.dart';

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

/// UseCase refresh token
final refreshTokenUseCaseProvider = Provider<RefreshTokenAccount>(
  (ref) => RefreshTokenAccount(ref.read(authRepositoryProvider)),
);

/// Notifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(refreshTokenUseCaseProvider), ref),
);
