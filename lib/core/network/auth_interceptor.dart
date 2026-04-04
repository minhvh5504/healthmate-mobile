import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth/auth_provider.dart';
import 'no_auth_paths.dart';

/// Handles proactive token refresh (before requests) and reactive refresh
/// (on 401 responses), with concurrent-request deduplication.
class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  /// Ensures only one refresh call runs at a time.
  /// Returns [true] if refresh succeeded, [false] otherwise.
  Future<bool> _refreshOnce() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      await ref.read(authProvider.notifier).refreshAccessToken();

      final token = ref.read(authProvider).accessToken;
      final success = token != null && token.isNotEmpty;

      _refreshCompleter!.complete(success);
      return success;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  bool _isPublicPath(String path) {
    return noAuthPaths.any((p) => path.contains(p));
  }

  /// Decodes the JWT [exp] claim without any third-party package.
  /// Returns [true] when the token is expired or unparseable.
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // JWT uses base64url encoding — normalise to standard base64.
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      // Pad to a multiple of 4.
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
      );

      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints.
    if (_isPublicPath(options.path)) {
      return handler.next(options);
    }

    final auth = ref.read(authProvider);

    // Proactively refresh if current access token is expired.
    if (auth.accessToken != null && _isTokenExpired(auth.accessToken!)) {
      await _refreshOnce();
    }

    final token = ref.read(authProvider).accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Avoid infinite refresh loop for the refresh endpoint itself.
    if (_isPublicPath(err.requestOptions.path)) {
      return handler.next(err);
    }

    final refreshed = await _refreshOnce();

    if (!refreshed) {
      // Refresh failed — let the UI handle the logged-out state.
      return handler.next(err);
    }

    final newToken = ref.read(authProvider).accessToken;

    // Retry the original request with the updated token.
    try {
      final retryOptions = err.requestOptions;
      if (newToken != null) {
        retryOptions.headers['Authorization'] = 'Bearer $newToken';
      }

      // dio.fetch re-uses existing interceptors, so create a plain Dio.
      final retryDio = Dio(
        BaseOptions(
          baseUrl: retryOptions.baseUrl,
          connectTimeout: retryOptions.connectTimeout,
          receiveTimeout: retryOptions.receiveTimeout,
          sendTimeout: retryOptions.sendTimeout,
          contentType: retryOptions.contentType,
          responseType: retryOptions.responseType,
        ),
      );

      final response = await retryDio.fetch(retryOptions);
      return handler.resolve(response);
    } catch (_) {
      return handler.next(err);
    }
  }
}
