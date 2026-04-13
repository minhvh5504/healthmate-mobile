import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify_password.dart';
import '../auth/auth_provider.dart';
import 'verify_password_notifier.dart';

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
