import '../repositories/auth_repository.dart';

class ResendCode {
  final AuthRepository repository;
  ResendCode(this.repository);

  Future<void> call(String email, String type) {
    return repository.resendOtp(email, type);
  }
}
