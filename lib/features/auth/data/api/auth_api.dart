import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/login/login_model.dart';
import '../models/register/register_model.dart';
import '../models/refresh_token/refresh_token_model.dart';
import '../models/verify_password/verify_password_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('auth/login')
  Future<LoginModel> login(@Body() Map<String, dynamic> body);

  @POST('auth/google')
  Future<LoginModel> loginWithGoogle(@Body() Map<String, dynamic> body);

  @POST('auth/register')
  Future<RegisterModel> register(@Body() Map<String, dynamic> body);

  @POST('auth/verify-email')
  Future<void> verifyEmail(@Body() Map<String, dynamic> body);

  @POST('auth/resend-otp')
  Future<void> resendOtp(@Body() Map<String, dynamic> body);

  @POST('auth/refresh')
  Future<RefreshTokenModel> refreshToken(@Body() Map<String, dynamic> body);

  @POST('auth/logout')
  Future<void> logout(@Body() Map<String, dynamic> body);

  @POST('auth/verify-password')
  Future<VerifyPasswordModel> verifyPassword(@Body() Map<String, dynamic> body);

  @POST('auth/reset-password')
  Future<void> resetPassword(@Body() Map<String, dynamic> body);

  @POST('auth/send-reset-password')
  Future<void> sendResetPassword(@Body() Map<String, dynamic> body);

  @GET('auth/profile')
  Future<dynamic> getProfile();
}
