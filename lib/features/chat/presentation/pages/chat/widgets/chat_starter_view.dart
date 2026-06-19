import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatStarterView extends ConsumerStatefulWidget {
  final Function(String) onSuggestionTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onBack;

  const ChatStarterView({
    super.key,
    required this.onSuggestionTap,
    required this.onHistoryTap,
    required this.onBack,
  });

  @override
  ConsumerState<ChatStarterView> createState() => _ChatStarterViewState();
}

class _ChatStarterViewState extends ConsumerState<ChatStarterView> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'chat.morning_greeting'.tr();
    } else if (hour >= 12 && hour < 18) {
      return 'chat.afternoon_greeting'.tr();
    } else {
      return 'chat.evening_greeting'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: widget.onBack,
                  borderRadius: BorderRadius.circular(50.r),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: AppColors.typoBlack,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onHistoryTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13172E),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'history.title'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          LucideIcons.history,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Image.asset(
              AppImages.aiChatIdle,
              width: 64.w,
              height: 64.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16.h),
            Text(
              _getGreeting(),
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: AppColors.typoBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'chat.welcome_subtitle'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                height: 1.4,
                color: AppColors.typoBody,
              ),
            ),
            SizedBox(height: 24.h),
            // Suggestions
            _buildSuggestionCard('chat.suggestion1'.tr()),
            _buildSuggestionCard('chat.suggestion2'.tr()),
            _buildSuggestionCard('chat.suggestion3'.tr()),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String text) {
    return GestureDetector(
      onTap: () => widget.onSuggestionTap(text),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.typoHeading.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.typoBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
