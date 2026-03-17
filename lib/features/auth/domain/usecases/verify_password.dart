import '../entities/verify_password.dart';
import '../repositories/auth_repository.dart';

class VerifyPasswordS {
  final AuthRepository repository;

  VerifyPasswordS(this.repository);

  Future<VerifyPassword> call(String email, String otp, String type) {
    return repository.verifyPassword(email, otp, type);
  }
}
