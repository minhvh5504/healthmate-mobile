import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
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

    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    state = const AuthState(isLoggedIn: false);
  }

  /// Refresh access token
  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final oldRefreshToken = prefs.getString('refresh_token');

    if (oldRefreshToken == null) return;

    try {
      final result = await refreshTokenUseCase(oldRefreshToken);

      if (result.accessToken.isEmpty || result.refreshToken.isEmpty) return;

      await prefs.setString('access_token', result.accessToken);
      await prefs.setString('refresh_token', result.refreshToken);

      state = state.copyWith(
        isLoggedIn: true,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
    } catch (e) {
      return;
    }
  }
}
