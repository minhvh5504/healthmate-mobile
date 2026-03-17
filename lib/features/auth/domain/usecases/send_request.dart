import '../repositories/auth_repository.dart';

class SendRequest {
  final AuthRepository repository;
  SendRequest(this.repository);

  Future<void> call(String email) {
    return repository.sendRequest(email);
  }
}
