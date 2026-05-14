import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    return Container(
      padding: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 14.h),
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(minHeight: 62.h),
          padding: EdgeInsets.only(left: 16.w, right: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999.r),
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
                  width: 46.r,
                  height: 46.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4D83F7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Icon(
                            LucideIcons.send,
                            color: Colors.white,
                            size: 22.r,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
