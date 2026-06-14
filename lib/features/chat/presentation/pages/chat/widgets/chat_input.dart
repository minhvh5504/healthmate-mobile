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
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
            _SendButton(
              onTap: _handleSend,
              isLoading: widget.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _SendButton({
    required this.onTap,
    required this.isLoading,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = 44.w;
    final double iconSize = 20.w;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isLoading
                    ? AppColors.bgDisable
                    : AppColors.chatSendButton,
                boxShadow: widget.isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.chatSendButton.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.send,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
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
