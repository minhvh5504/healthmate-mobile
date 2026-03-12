import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify.dart';
import 'verify_account_notifier.dart';

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

/// UseCase verify
final verifyAccountUseCaseProvider = Provider<Verify>(
  (ref) => Verify(ref.read(authRepositoryProvider)),
);

/// UseCase resend code
final resendCodeUseCaseProvider = Provider<ResendCode>(
  (ref) => ResendCode(ref.read(authRepositoryProvider)),
);

/// Notifier
final verifyAccountNotifierProvider =
    StateNotifierProvider<VerifyAccountNotifier, VerifyAccountState>(
      (ref) => VerifyAccountNotifier(
        ref.read(verifyAccountUseCaseProvider),
        ref.read(resendCodeUseCaseProvider),
        ref,
      ),
    );
