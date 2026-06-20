import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
  await PushNotificationService._showLocalNotification(message);
}

/// Manages FCM registration, device token uploads, and local notification display.
class PushNotificationService {
  static final _fln = FlutterLocalNotificationsPlugin();
  static const _channelId = 'healthmate_notifications';
  static const _channelName = 'Healthmate Notifications';

  static bool _initialized = false;
  static late Future<void> Function(String token) _onTokenRefresh;
  static late void Function(RemoteMessage message) _onForegroundMessage;
  static late void Function(RemoteMessage? message) _onMessageOpenedApp;

  /// Initialize local notifications and FCM listeners.
  static Future<void> initialize({
    required Future<void> Function(String token) onTokenRefresh,
    required void Function(RemoteMessage message) onForegroundMessage,
    required void Function(RemoteMessage? message) onMessageOpenedApp,
  }) async {
    // Keep callbacks current when ProviderScope is reset, but install the
    // Firebase listeners only once for the lifetime of the process.
    _onTokenRefresh = onTokenRefresh;
    _onForegroundMessage = onForegroundMessage;
    _onMessageOpenedApp = onMessageOpenedApp;
    if (_initialized) return;
    _initialized = true;

    // Local Notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _fln.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        // Handle local notification tap
        _onMessageOpenedApp(null);
      },
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              importance: Importance.high,
              enableVibration: true,
              playSound: true,
            ),
          );
    }

    // FCM Permissions
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Foreground presentation options on iOS
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground handler
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM] Foreground message: ${message.messageId}');
      _showLocalNotification(message);
      _onForegroundMessage(message);
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check if app was launched from a terminated-state notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }

    // ---------- Token management ----------
    final token = await messaging.getToken();
    if (token != null) {
      debugPrint('[FCM] Token: $token');
      await _onTokenRefresh(token);
    }

    messaging.onTokenRefresh.listen((newToken) async {
      debugPrint('[FCM] Token refreshed');
      await _onTokenRefresh(newToken);
    });
  }

  /// Show a local notification from a RemoteMessage.
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _fln.show(
      message.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
