import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify_password.dart';
import 'verify_password_notifier.dart';

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
final verifyPasswordProvider = Provider<VerifyPasswordS>(
  (ref) => VerifyPasswordS(ref.read(authRepositoryProvider)),
);

final resendCodeUseCaseProvider = Provider<ResendCode>(
  (ref) => ResendCode(ref.read(authRepositoryProvider)),
);

/// Notifier
final verifyPasswordNotifierProvider =
    StateNotifierProvider<VerifyPasswordNotifier, VerifyPasswordState>(
      (ref) => VerifyPasswordNotifier(
        ref.read(verifyPasswordProvider),
        ref.read(resendCodeUseCaseProvider),
        ref,
      ),
    );
