import '../repositories/auth_repository.dart';

class Verify {
  final AuthRepository repository;
  Verify(this.repository);

  Future<void> call(String email, String otp, String type) {
    return repository.verifyEmail(email, otp, type);
  }
}
