import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_base.dart';
import '../services/socket_realtime_service.dart';
import '../../features/auth/presentation/providers/auth/auth_provider.dart';

/// Singleton SocketRealtimeService provider.
final realtimeServiceProvider = Provider<SocketRealtimeService>((ref) {
  final service = SocketRealtimeService();
  var disposed = false;

  Future<void> registerCurrentDeviceToken(String accessToken) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (disposed || fcmToken == null) return;

    await ref
        .read(deviceTokenServiceProvider)
        .registerToken(fcmToken, accessToken: accessToken);
  }

  // Auto-connect when auth token is available, auto-disconnect on logout.
  ref.listen(authProvider, (prev, next) {
    final token = next.accessToken;
    if (token != null && prev?.accessToken != token) {
      service.connect(token);

      // Also trigger device token registration on login.
      registerCurrentDeviceToken(token);
    } else if (token == null && prev?.accessToken != null) {
      service.disconnect();
    }
  });

  // Connect immediately if already logged in (e.g., app restart)
  final initialToken = ref.read(authProvider).accessToken;
  if (initialToken != null) {
    service.connect(initialToken);

    // Trigger initial registration.
    registerCurrentDeviceToken(initialToken);
  }

  ref.onDispose(() {
    disposed = true;
    service.dispose();
  });
  return service;
});

/// Provider for uploading / refreshing the FCM device token to the backend.
final deviceTokenServiceProvider = Provider<DeviceTokenService>((ref) {
  return DeviceTokenService(ref);
});

class DeviceTokenService {
  final Ref _ref;
  static const _key = 'fcm_device_token';

  DeviceTokenService(this._ref);

  /// Register (or refresh) FCM token with the backend.
  Future<void> registerToken(String token, {String? accessToken}) async {
    final authToken = accessToken ?? _ref.read(authProvider).accessToken;
    if (authToken == null || authToken.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Always register on login. Backend upsert moves this device token
      // to the currently authenticated account when users switch accounts.
      final dio = Dio(BaseOptions(baseUrl: ApiBase.baseUrl));
      await dio.post(
        'notifications/device-tokens',
        data: {'token': token, 'platform': _getPlatform()},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      await prefs.setString(_key, token);
    } catch (e) {
      // Non-critical: log and continue.
    }
  }

  /// Unregister and rotate the FCM token when the current account logs out.
  Future<void> unregisterToken({String? accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString(_key) ?? await FirebaseMessaging.instance.getToken();
    final authToken = accessToken ?? _ref.read(authProvider).accessToken;

    try {
      if (token != null && authToken != null && authToken.isNotEmpty) {
        final dio = Dio(BaseOptions(baseUrl: ApiBase.baseUrl));
        await dio.delete(
          'notifications/device-tokens',
          queryParameters: {'token': token},
          options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        );
      }
    } catch (_) {
      // Non-critical: deleting the local FCM token still invalidates it.
    } finally {
      await prefs.remove(_key);
      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {}
    }
  }

  String _getPlatform() => Platform.isIOS ? 'ios' : 'android';
}
