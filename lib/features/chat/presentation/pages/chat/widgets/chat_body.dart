import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/chat/domain/entities/chat_message.dart';
import 'package:healthmate_mobile/features/chat/presentation/providers/chat/chat_notifier.dart';
import 'chat_bubble.dart';
import 'chat_starter_view.dart';

class ChatBody extends StatelessWidget {
  final ChatState state;
  final ChatNotifier notifier;
  final ScrollController scrollController;
  final bool hasMessages;
  final VoidCallback onBack;

  const ChatBody({
    super.key,
    required this.state,
    required this.notifier,
    required this.scrollController,
    required this.hasMessages,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && !hasMessages) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasMessages) {
      return ChatStarterView(
        onSuggestionTap: notifier.sendMessage,
        onHistoryTap: notifier.fetchHistory,
        onBack: onBack,
      );
    }

    final showStreaming =
        state.streamingContent != null && state.streamingContent!.isNotEmpty;

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: state.messages.length + (showStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (showStreaming) {
          if (index == 0) {
            return ChatBubble(
              message: ChatMessage(
                id: 'streaming',
                content: state.streamingContent!,
                role: 'assistant',
                createdAt: DateTime.now(),
              ),
              isStreaming: true,
            );
          }
          final messageIndex = state.messages.length - index;
          final message = state.messages[messageIndex];
          if (index == 1 && message.role == 'assistant') {
            return const SizedBox.shrink();
          }

          return ChatBubble(message: message);
        } else {
          final messageIndex = state.messages.length - 1 - index;
          return ChatBubble(message: state.messages[messageIndex]);
        }
      },
    );
  }
}
