import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/realtime_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecases/refresh_token_account.dart';

/// STATE
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.isLoggedIn = false,

    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

/// NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final RefreshTokenAccount refreshTokenUseCase;
  final Ref ref;

  AuthNotifier(this.refreshTokenUseCase, this.ref) : super(const AuthState()) {
    loadAuth();
  }

  /// Load auth
  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (!isLogin || accessToken == null || refreshToken == null) {
      return;
    }

    if (_isTokenExpired(accessToken)) {
      await refreshAccessToken();
      return;
    }

    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      payload = payload.padRight(
        payload.length + (4 - payload.length % 4) % 4,
        '=',
      );

      final jsonBytes = base64Decode(payload);
      final jsonStr = utf8.decode(jsonBytes);
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;

      final exp = map['exp'];
      if (exp == null) return false;

      final expiry = DateTime.fromMillisecondsSinceEpoch(
        (exp as num).toInt() * 1000,
        isUtc: true,
      );

      return DateTime.now()
          .toUtc()
          .add(const Duration(seconds: 30))
          .isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  /// Login
  Future<void> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setBool('isLogin', true);

    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Logout
  ///
  /// Local auth is cleared FIRST so any subsequent in-flight request
  /// (e.g. the device-token unregister call below) cannot be picked up by
  /// [AuthInterceptor] as an "expired token → refresh → logout" cascade,
  /// which previously caused an infinite loop when the network was down.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.setBool('isLogin', false);

    state = const AuthState(isLoggedIn: false);

    // Best-effort backend unregister. Failures are intentionally swallowed.
    try {
      await ref.read(deviceTokenServiceProvider).unregisterToken();
    } catch (_) {
      // Non-critical: user is already logged out locally.
    }
  }

  /// Refresh access token.
  ///
  /// Returns `true` on success, `false` on failure.
  ///
  /// IMPORTANT: We only force a logout when the server explicitly rejects the
  /// refresh token (HTTP 401/403). Transient errors such as connection
  /// timeouts or no-internet conditions return `false` without clearing the
  /// session, so the user can retry once connectivity is restored.
  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final oldRefreshToken = prefs.getString('refresh_token');

    // No refresh token means the user is already logged out (or never logged
    // in). Do NOT call logout() here, otherwise an interceptor that triggers
    // a refresh on a 401 from the unregister-device-token call could cause
    // recursive logout calls.
    if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
      return false;
    }

    try {
      final result = await refreshTokenUseCase(oldRefreshToken);

      if (result.accessToken.isEmpty) {
        // Server replied successfully but with an empty token — treat as an
        // auth failure.
        await logout();
        return false;
      }

      await prefs.setString('access_token', result.accessToken);
      await prefs.setString('refresh_token', result.refreshToken);

      state = state.copyWith(
        isLoggedIn: true,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      // Only force logout when the server explicitly rejects the refresh
      // token. Connection timeouts, DNS errors, no internet etc. leave the
      // session intact so the user can retry.
      if (status == 401 || status == 403) {
        await logout();
      }
      return false;
    } catch (_) {
      // Unknown error: fail safely without destroying the session.
      return false;
    }
  }
}
