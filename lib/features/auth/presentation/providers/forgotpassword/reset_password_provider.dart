import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/reset_password.dart';
import '../auth/auth_provider.dart';
import 'reset_password_notifier.dart';

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
