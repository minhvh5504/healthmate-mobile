import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/socket_realtime_provider.dart';
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

    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
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
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAccessToken =
        state.accessToken ?? prefs.getString('access_token');

    // Unregister this device while the old account token is still valid.
    try {
      await ref
          .read(deviceTokenServiceProvider)
          .unregisterToken(accessToken: currentAccessToken);
    } catch (_) {}

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.setBool('isLogin', false);

    state = const AuthState(isLoggedIn: false);
  }

  /// Refresh access token.
  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final oldRefreshToken = prefs.getString('refresh_token');

    if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
      return false;
    }

    try {
      final result = await refreshTokenUseCase(oldRefreshToken);

      if (result.accessToken.isEmpty) {
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

      if (status == 401 || status == 403) {
        await logout();
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
