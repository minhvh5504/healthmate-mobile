import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/chat_api.dart';
import '../../../data/datasources/chat_remote_datasource.dart';
import '../../../data/repositories/chat_repository_impl.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/send_chat_message.dart';
import '../../../domain/usecases/get_chat_history.dart';
import 'chat_notifier.dart';

export 'chat_notifier.dart';

/// Api Provider
final chatApiProvider = Provider<ChatApi>((ref) {
  return ApiClient(ref).create(ChatApi.new);
});

/// Data Source Provider
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(
    ref.read(chatApiProvider),
    ApiClient(ref).dio, // Get raw Dio for streaming
  );
});

/// Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider));
});

/// Usecase Send Message
final sendChatMessageUseCaseProvider = Provider<SendChatMessage>((ref) {
  return SendChatMessage(ref.read(chatRepositoryProvider));
});

/// Usecase Get History
final getChatHistoryUseCaseProvider = Provider<GetChatHistory>((ref) {
  return GetChatHistory(ref.read(chatRepositoryProvider));
});

/// StateNotifier Provider
final chatProvider = StateNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  (ref) {
    return ChatNotifier(
      ref.read(sendChatMessageUseCaseProvider),
      ref.read(getChatHistoryUseCaseProvider),
      ref,
    );
  },
);
