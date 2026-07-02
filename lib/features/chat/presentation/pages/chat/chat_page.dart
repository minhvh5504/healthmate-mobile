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
  bool _isScrollToBottomQueued = false;

  @override
  void initState() {
    super.initState();
    _scheduleScrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleScrollToBottom() {
    if (_isScrollToBottomQueued || !mounted) return;

    _isScrollToBottomQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isScrollToBottomQueued = false;
      if (!mounted) return;
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (!position.hasPixels || !position.hasContentDimensions) {
      _scheduleScrollToBottom();
      return;
    }

    position
        .animateTo(
          position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        )
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);

    ref.listen(chatProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0) ||
          next.streamingContent != previous?.streamingContent) {
        _scheduleScrollToBottom();
      }
    });

    final hasMessages =
        state.messages.isNotEmpty || state.streamingContent != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasMessages)
                ChatHeader(
                  hasMessages: hasMessages,
                  onBack: () => Navigator.pop(context),
                  onClearHistory: notifier.clearHistory,
                ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ChatBody(
                        state: state,
                        notifier: notifier,
                        scrollController: _scrollController,
                        hasMessages: hasMessages,
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                    if (state.errorMessage != null)
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 96.h,
                        child: _buildErrorBanner(state, notifier),
                      ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ChatInput(
                        onSend: notifier.sendMessage,
                        isLoading: state.isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ChatState state, ChatNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.typoBlack.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: -10,
            offset: const Offset(0, 12),
          ),
        ],
      ),
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
