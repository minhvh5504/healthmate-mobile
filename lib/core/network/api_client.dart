// api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_base.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final Dio dio;

  // Private constructor
  ApiClient._(this.dio);

  factory ApiClient(Ref ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBaseDev.baseUrlDevelopment,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        contentType: 'application/json; charset=UTF-8',
        responseType: ResponseType.json,
      ),
    );

    // Logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    // Token interceptor
    dio.interceptors.add(AuthInterceptor(ref));

    return ApiClient._(dio);
  }

  /// Case 1: Retrofit Service Creation (Case main app)
  T create<T>(T Function(Dio dio) builder) {
    return builder(dio);
  }

  /// Case 2: Manual HTTP Requests with Dio (GET/POST/PATCH/DELETE)
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await dio.get(path, queryParameters: query);
    return res.data;
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await dio.post(path, data: body);
    return res.data;
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await dio.patch(path, data: body);
    return res.data;
  }

  Future<dynamic> delete(String path) async {
    final res = await dio.delete(path);
    return res.data;
  }
}
