import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;
  ResetPassword(this.repository);

  Future<void> call(String resetToken, String newPassword) {
    return repository.resetPassword(resetToken, newPassword);
  }
}
