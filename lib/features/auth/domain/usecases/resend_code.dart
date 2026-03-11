import '../repositories/auth_repository.dart';

class ResendCode {
  final AuthRepository repository;
  ResendCode(this.repository);

  Future<void> call(String phone) {
    return repository.resendOtp(phone);
  }
}
