import '../entities/login.dart';
import '../repositories/auth_repository.dart';

class LoginAccount {
  final AuthRepository repository;
  LoginAccount(this.repository);

  Future<Login> call(
    String phone,
    String password,
    String loginRole,
    String origin,
  ) {
    return repository.login(phone, password, loginRole, origin);
  }
}
