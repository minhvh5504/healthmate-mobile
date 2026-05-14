import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendChatMessage {
  final ChatRepository _repository;

  SendChatMessage(this._repository);

  Stream<String> call({
    required String message,
    required String token,
    List<ChatMessage> history = const [],
  }) {
    return _repository.sendMessage(
      message: message,
      token: token,
      history: history,
    );
  }
}
