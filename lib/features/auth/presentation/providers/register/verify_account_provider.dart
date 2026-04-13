import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify.dart';
import '../auth/auth_provider.dart';
import 'verify_account_notifier.dart';

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
