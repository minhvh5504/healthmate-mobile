import '../entities/login.dart';
import '../entities/refresh_token.dart';
import '../entities/register.dart';

abstract class AuthRepository {
  Future<Login> login(
    String identifier,
    String password,
    String loginRole,
    String origin,
  );
  Future<Login> loginWithGoogle(String idToken);
  Future<Register> register(String email, String password);
  // Future<void> sendRequest(String phone);
  Future<void> verifyPhone(String phone, String otp);
  Future<void> resendOtp(String phone);
  // Future<void> resetPassword(String phone, String newPassword);
  Future<RefreshToken> refreshToken(String refreshToken);
}
