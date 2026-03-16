import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/login_account.dart';
import '../../../domain/usecases/login_with_google.dart';
import 'login_notifier.dart';

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

/// UseCase login
final loginUseCaseProvider = Provider<LoginAccount>(
  (ref) => LoginAccount(ref.read(authRepositoryProvider)),
);

/// UseCase login with google
final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogle>(
  (ref) => LoginWithGoogle(ref.read(authRepositoryProvider)),
);

/// Notifier
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.read(loginUseCaseProvider), ref),
);
