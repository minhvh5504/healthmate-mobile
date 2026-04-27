import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../routing/app_router.dart';
import '../routing/app_routes.dart';

class NotificationHandler {
  static void handleNotificationTap(RemoteMessage? message) {
    debugPrint('App opened from notification: ${message?.messageId}');

    final router = AppRouter.router;

    try {
      final currentMatch = router.routerDelegate.currentConfiguration.last;
      final currentPath = currentMatch.matchedLocation;

      if (currentPath != AppRoutes.splash) {
        router.push(AppRoutes.notifications);
      }
    } catch (e) {
      debugPrint('Error during notification navigation: $e');
    }
  }
}
