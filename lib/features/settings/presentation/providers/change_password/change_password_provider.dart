import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_provider.dart';
import '../../../domain/usecases/change_password.dart';
import 'change_password_notifier.dart';

final changePasswordUseCaseProvider = Provider<ChangePassword>(
  (ref) => ChangePassword(ref.read(settingsRepositoryProvider)),
);

final changePasswordNotifierProvider =
    StateNotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>(
  (ref) => ChangePasswordNotifier(ref.read(changePasswordUseCaseProvider)),
);
