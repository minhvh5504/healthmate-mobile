import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInput({super.key, required this.onSend, this.isLoading = false});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _isSending = false;

  void _handleSend() {
    if (_isSending) return;

    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;

    setState(() => _isSending = true);

    // Clear controller first to prevent double trigger from UI
    _controller.clear();
    widget.onSend(text);

    // Reset flag after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isSending = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendButtonPadding = 12.r;
    final sendIconSize = 22.r;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        constraints: BoxConstraints(minHeight: 62.h),
        padding: EdgeInsets.only(left: 16.w, right: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.typoBlack.withValues(alpha: 0.14),
              blurRadius: 28,
              spreadRadius: -10,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(
                  color: AppColors.typoBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'chat.hint'.tr(),
                  hintStyle: TextStyle(
                    color: const Color(0xFFAEB7C4),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                padding: EdgeInsets.all(sendButtonPadding),
                decoration: BoxDecoration(
                  color: widget.isLoading
                      ? AppColors.bgDisable
                      : AppColors.chatSendButton,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: sendIconSize,
                          height: sendIconSize,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : SvgPicture.asset(
                          AppIcons.send,
                          width: sendIconSize,
                          height: sendIconSize,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
