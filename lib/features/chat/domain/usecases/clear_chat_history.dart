import '../repositories/chat_repository.dart';

class ClearChatHistory {
  final ChatRepository _repository;

  ClearChatHistory(this._repository);

  Future<void> call() {
    return _repository.clearChatHistory();
  }
}
