import '../../domain/entities/login.dart';
import '../../domain/entities/refresh_token.dart';
import '../../domain/entities/register.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Login> login(
    String identifier,
    String password,
    String loginRole,
    String origin,
  ) {
    return remoteDataSource.login(identifier, password, loginRole, origin);
  }

  @override
  Future<Login> loginWithGoogle(String idToken) {
    return remoteDataSource.loginWithGoogle(idToken);
  }

  @override
  Future<Register> register(String email, String password) async {
    return remoteDataSource.register(email, password);
  }

  // @override
  // Future<void> sendRequest(String phone) {
  //   return remoteDataSource.sendRequest(phone);
  // }

  @override
  Future<void> verifyEmail(String email, String otp) {
    return remoteDataSource.verifyEmail(email, otp);
  }

  @override
  Future<void> resendOtp(String email) {
    return remoteDataSource.resendOtp(email);
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
