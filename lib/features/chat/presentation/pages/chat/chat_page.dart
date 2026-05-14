import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/chat/chat_provider.dart';
import 'widgets/chat_body.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_input.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    ref.listen(chatProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0) ||
          next.streamingContent != previous?.streamingContent) {
        _scrollToBottom();
      }
    });

    final hasMessages =
        state.messages.isNotEmpty || state.streamingContent != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: hasMessages
          ? ChatHeader(
              hasMessages: hasMessages,
              onBack: () => Navigator.pop(context),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Column(
          children: [
            Expanded(
              child: ChatBody(
                state: state,
                notifier: notifier,
                scrollController: _scrollController,
                hasMessages: hasMessages,
                onBack: () => Navigator.pop(context),
              ),
            ),
            if (state.errorMessage != null) _buildErrorBanner(state, notifier),
            ChatInput(onSend: notifier.sendMessage, isLoading: state.isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ChatState state, ChatNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(8.r),
      color: AppColors.typoError.withValues(alpha: 0.1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: AppColors.typoError, fontSize: 12.sp),
            ),
          ),
          IconButton(
            icon: const Icon(
              LucideIcons.x,
              size: 16,
              color: AppColors.typoError,
            ),
            onPressed: notifier.clearError,
          ),
        ],
      ),
    );
  }
}
