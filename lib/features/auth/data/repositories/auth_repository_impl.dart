import '../../domain/entities/login.dart';
import '../../domain/entities/refresh_token.dart';
import '../../domain/entities/register.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/verify_password.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Login> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<Login> loginWithGoogle(String idToken) {
    return remoteDataSource.loginWithGoogle(idToken);
  }

  @override
  Future<Register> register(String email, String password) async {
    return remoteDataSource.register(email, password);
  }

  @override
  Future<void> sendRequest(String email) {
    return remoteDataSource.sendResetPassword(email);
  }

  @override
  Future<void> verifyEmail(String email, String otp, String type) {
    return remoteDataSource.verifyEmail(email, otp, type);
  }

  @override
  Future<VerifyPassword> verifyPassword(String email, String otp, String type) {
    return remoteDataSource.verifyPassword(email, otp, type);
  }

  @override
  Future<void> resendOtp(String email, String type) {
    return remoteDataSource.resendOtp(email, type);
  }

  // @override
  // Future<void> resetPassword(String phone, String newPassword) {
  //   return remoteDataSource.resetPassword(phone, newPassword);
  // }

  @override
  Future<RefreshToken> refreshToken(String refreshToken) {
    return remoteDataSource.refreshToken(refreshToken);
  }
}
