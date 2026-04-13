import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/send_request.dart';
import '../auth/auth_provider.dart';
import 'send_request_notifier.dart';

/// UseCase
final sendRequestUseCaseProvider = Provider<SendRequest>(
  (ref) => SendRequest(ref.read(authRepositoryProvider)),
);

/// Notifier
final sendRequestNotifierProvider =
    StateNotifierProvider<SendRequestNotifier, SendRequestState>(
      (ref) => SendRequestNotifier(ref.read(sendRequestUseCaseProvider), ref),
    );
