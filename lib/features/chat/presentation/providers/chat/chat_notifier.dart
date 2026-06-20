import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/auth/presentation/providers/auth/auth_provider.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/usecases/send_chat_message.dart';
import '../../../domain/usecases/get_chat_history.dart';
import '../../../domain/usecases/clear_chat_history.dart';

/// State
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? streamingContent;
  final String? errorMessage;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.streamingContent,
    this.errorMessage,
  });

  static const _unset = Object();

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    Object? streamingContent = _unset,
    Object? errorMessage = _unset,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      streamingContent: streamingContent == _unset
          ? this.streamingContent
          : streamingContent as String?,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

/// Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final SendChatMessage _sendChatMessage;
  final GetChatHistory _getChatHistory;
  final ClearChatHistory _clearChatHistory;
  final Ref _ref;

  ChatNotifier(
    this._sendChatMessage,
    this._getChatHistory,
    this._clearChatHistory,
    this._ref,
  ) : super(ChatState());

  Future<void> fetchHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final history = await _getChatHistory();
      if (!mounted) return;
      state = state.copyWith(messages: history, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.isLoading) return;

    final token = _ref.read(authProvider).accessToken ?? '';

    final userMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      role: 'user',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      streamingContent: '',
      errorMessage: null,
    );

    try {
      final stream = _sendChatMessage(
        message: content,
        token: token,
        history: state.messages.take(state.messages.length - 1).toList(),
      );

      String fullResponse = '';
      await for (final chunk in stream) {
        if (!mounted) return;
        fullResponse += chunk;
        state = state.copyWith(streamingContent: fullResponse);
      }

      if (!mounted) return;

      if (fullResponse.trim().isNotEmpty) {
        final assistantId = 'ai_${userMessage.id}';
        final assistantMessage = ChatMessage(
          id: assistantId,
          content: fullResponse.trim(),
          role: 'assistant',
          createdAt: DateTime.now(),
        );

        final alreadyExists = state.messages.any(
          (m) =>
              m.id == assistantId ||
              (m.role == 'assistant' && m.content == assistantMessage.content),
        );

        if (!alreadyExists) {
          state = state.copyWith(
            messages: [...state.messages, assistantMessage],
            streamingContent: null,
            isLoading: false,
          );
        } else {
          state = state.copyWith(streamingContent: null, isLoading: false);
        }
      } else {
        state = state.copyWith(streamingContent: null, isLoading: false);
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        streamingContent: null,
        errorMessage: AppToast.message(e),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> clearHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _clearChatHistory();
      if (!mounted) return;
      state = ChatState();
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
    }
  }
}
