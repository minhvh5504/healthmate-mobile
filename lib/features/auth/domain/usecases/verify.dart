import '../repositories/auth_repository.dart';

class Verify {
  final AuthRepository repository;
  Verify(this.repository);

  Future<void> call(String phone, String otp) {
    return repository.verifyPhone(phone, otp);
  }
}
