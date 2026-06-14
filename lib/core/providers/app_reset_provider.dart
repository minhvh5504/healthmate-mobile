import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/handlers/notification_handler.dart';
import 'package:healthmate_mobile/core/providers/socket_realtime_provider.dart';
import 'package:healthmate_mobile/features/auth/presentation/providers/auth/auth_provider.dart';
import 'package:healthmate_mobile/core/services/push_notification_service.dart';

class AppResetProvider extends ChangeNotifier {
  static final AppResetProvider _instance = AppResetProvider._internal();
  factory AppResetProvider() => _instance;
  AppResetProvider._internal();

  void reset() {
    notifyListeners();
  }
}

final appBootstrapProvider = FutureProvider<void>((ref) async {
  var disposed = false;
  ref.onDispose(() => disposed = true);

  await PushNotificationService.initialize(
    onTokenRefresh: (token) async {
      if (disposed) return;

      final accessToken = ref.read(authProvider).accessToken;
      if (accessToken == null || accessToken.isEmpty) return;

      await ref
          .read(deviceTokenServiceProvider)
          .registerToken(token, accessToken: accessToken);
    },
    onForegroundMessage: (message) {
      debugPrint('Received foreground message: ${message.messageId}');
    },
    onMessageOpenedApp: NotificationHandler.handleNotificationTap,
  );
});
