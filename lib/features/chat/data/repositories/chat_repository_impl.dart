import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ChatMessage>> getChatHistory() async {
    return _remoteDataSource.getChatHistory();
  }

  @override
  Stream<String> sendMessage({
    required String message,
    required String token,
    List<ChatMessage> history = const [],
  }) {
    final historyModels = history
        .map((e) => ChatMessageModel.fromEntity(e))
        .toList();

    return _remoteDataSource.sendMessage(
      message: message,
      token: token,
      history: historyModels,
    );
  }

  @override
  Future<void> clearChatHistory() {
    return _remoteDataSource.clearChatHistory();
  }
}
