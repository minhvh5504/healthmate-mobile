import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/register_account.dart';
import '../auth/auth_provider.dart';
import 'register_notifier.dart';

/// UseCase
final registerUseCaseProvider = Provider<RegisterAccount>(
  (ref) => RegisterAccount(ref.read(authRepositoryProvider)),
);

/// Notifier
final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>(
      (ref) => RegisterNotifier(ref.read(registerUseCaseProvider), ref),
    );
