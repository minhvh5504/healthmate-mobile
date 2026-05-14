import '../entities/chat_message.dart';

abstract class ChatRepository {
  /// Sends a message and returns a stream of message chunks (SSE)
  Stream<String> sendMessage({
    required String message,
    required String token,
    List<ChatMessage> history = const [],
  });

  /// Fetches chat history from the backend if needed
  Future<List<ChatMessage>> getChatHistory();
}
