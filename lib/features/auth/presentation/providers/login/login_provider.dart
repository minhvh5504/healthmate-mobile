import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/login_account.dart';
import '../../../domain/usecases/login_with_google.dart';
import '../auth/auth_provider.dart';
import 'login_notifier.dart';

/// UseCase login
final loginUseCaseProvider = Provider<LoginAccount>(
  (ref) => LoginAccount(ref.read(authRepositoryProvider)),
);

/// UseCase login with google
final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogle>(
  (ref) => LoginWithGoogle(ref.read(authRepositoryProvider)),
);

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    ref.read(loginUseCaseProvider),
    ref.read(loginWithGoogleUseCaseProvider),
    ref,
  ),
);
