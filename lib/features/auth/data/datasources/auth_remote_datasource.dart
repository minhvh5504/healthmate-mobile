import '../api/auth_api.dart';
import '../models/login/login_model.dart';
import '../models/register/register_model.dart';
import '../models/refresh_token/refresh_token_model.dart';
import '../models/verify_password/verify_password_model.dart';

class AuthRemoteDataSource {
  final AuthApi api;

  AuthRemoteDataSource(this.api);

  Future<LoginModel> login(String email, String password) {
    return api.login({'email': email, 'password': password});
  }

  Future<LoginModel> loginWithGoogle(String idToken) {
    return api.loginWithGoogle({'idToken': idToken});
  }

  Future<RegisterModel> register(String email, String password) {
    return api.register({'email': email, 'password': password});
  }

  Future<void> verifyEmail(String email, String code, String type) {
    return api.verifyEmail({'email': email, 'code': code, 'type': type});
  }

  Future<void> resendOtp(String email, String type) {
    return api.resendOtp({'email': email, 'type': type});
  }

  Future<VerifyPasswordModel> verifyPassword(
    String email,
    String code,
    String type,
  ) {
    return api.verifyPassword({'email': email, 'code': code, 'type': type});
  }

  Future<void> resetPassword(String resetToken, String newPassword) {
    return api.resetPassword({
      'resetToken': resetToken,
      'newPassword': newPassword,
    });
  }

  Future<void> sendResetPassword(String email) {
    return api.sendResetPassword({'email': email});
  }

  Future<RefreshTokenModel> refreshToken(String refreshToken) {
    return api.refreshToken({'refreshToken': refreshToken});
  }
}
