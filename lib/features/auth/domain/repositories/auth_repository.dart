import '../entities/login.dart';
import '../entities/refresh_token.dart';
import '../entities/register.dart';
import '../entities/verify_password.dart';

abstract class AuthRepository {
  Future<Login> login(String email, String password);
  Future<Login> loginWithGoogle(String idToken);
  Future<Register> register(String email, String password);
  Future<void> sendRequest(String email);
  Future<void> verifyEmail(String email, String otp, String type);
  Future<VerifyPassword> verifyPassword(String email, String otp, String type);
  Future<void> resendOtp(String email, String type);
  Future<void> resetPassword(String resetToken, String newPassword);
  Future<RefreshToken> refreshToken(String refreshToken);
}
