import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/chat/domain/entities/chat_message.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isStreaming;

  const ChatBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    if (!isUser) {
      return _AssistantMessage(
        content: message.content,
        isStreaming: isStreaming,
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 64.w, right: 16.w, bottom: 10.h),
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        decoration: BoxDecoration(
          color: AppColors.chatSendButton,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: AppColors.typoWhite,
            fontSize: 14.sp,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

class _AssistantMessage extends StatelessWidget {
  final String content;
  final bool isStreaming;

  const _AssistantMessage({required this.content, required this.isStreaming});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.chatSendButton),
              boxShadow: [
                BoxShadow(
                  color: AppColors.typoBlack.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chatSendButton.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.blur_on,
                        size: 14.sp,
                        color: AppColors.chatSendButton,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'AI',
                        style: TextStyle(
                          color: AppColors.chatSendButton,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                isStreaming && content == '...'
                    ? const _TypingDotsIndicator()
                    : Text(
                        content,
                        style: TextStyle(
                          color: AppColors.typoBlack,
                          fontSize: 14.sp,
                          height: 1.28,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDotsIndicator extends StatefulWidget {
  const _TypingDotsIndicator();

  @override
  State<_TypingDotsIndicator> createState() => _TypingDotsIndicatorState();
}

class _TypingDotsIndicatorState extends State<_TypingDotsIndicator> {
  // Forward: 0 → 1 → 2 → 0 → 1 → 2 → ...
  static const _sequence = [0, 1, 2];
  int _step = 0;

  late final Stream<int> _ticker;
  late final StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _ticker = Stream<int>.periodic(
      const Duration(milliseconds: 400),
      (i) => i,
    );
    _sub = _ticker.listen((_) {
      if (!mounted) return;
      setState(() => _step = (_step + 1) % _sequence.length);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: AnimatedSmoothIndicator(
        activeIndex: _sequence[_step],
        count: 3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        effect: ExpandingDotsEffect(
          dotHeight: 8.h,
          dotWidth: 8.w,
          expansionFactor: 1.5,
          spacing: 6.w,
          dotColor: AppColors.chatSendButton.withValues(alpha: 0.3),
          activeDotColor: AppColors.chatSendButton,
        ),
      ),
    );
  }
}
