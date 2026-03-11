import '../api/auth_api.dart';
import '../models/login/login_model.dart';
import '../models/register/register_model.dart';
import '../models/refresh_token/refresh_token_model.dart';

class AuthRemoteDataSource {
  final AuthApi api;

  AuthRemoteDataSource(this.api);

  Future<LoginModel> login(
    String identifier,
    String password,
    String loginRole,
    String origin,
  ) {
    return api.login({
      'identifier': identifier,
      'password': password,
      // 'loginRole': loginRole,
      // 'origin': origin,
    });
  }

  Future<LoginModel> loginWithGoogle(String idToken) {
    return api.loginWithGoogle({'idToken': idToken});
  }

  Future<RegisterModel> register(
    String fullName,
    String phone,
    String password,
    String role,
  ) {
    return api.register({
      'fullName': fullName,
      'phone': phone,
      'password': password,
      // 'role': role,
    });
  }

  // Future<void> sendRequest(String phone) {
  //   return api.sendRequest({'phone': phone});
  // }

  Future<void> verifyPhone(String phone, String otp) {
    return api.verifyPhone({'phone': phone, 'otp': otp});
  }

  Future<void> resendOtp(String phone) {
    return api.resendOtp({'phone': phone});
  }

  // Future<void> resetPassword(String phone, String newPassword) {
  //   return api.resetPassword({'phone': phone, 'password': newPassword});
  // }

  Future<RefreshTokenModel> refreshToken(String refreshToken) {
    return api.refreshToken({'refreshToken': refreshToken});
  }
}
