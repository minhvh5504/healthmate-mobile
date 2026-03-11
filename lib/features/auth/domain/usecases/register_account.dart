import '../entities/register.dart';
import '../repositories/auth_repository.dart';

class RegisterAccount {
  final AuthRepository repository;
  RegisterAccount(this.repository);

  Future<Register> call(
    String fullName,
    String phone,
    String password,
    String role,
  ) {
    return repository.register(fullName, phone, password, role);
  }
}
