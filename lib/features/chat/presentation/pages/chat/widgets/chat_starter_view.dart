import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/providers/user_provider.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProfileProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final fullName = user?.displayName ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
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
          SizedBox(height: 20.h),
          // Welcome Title
          Text(
            'chat.welcome'.tr(args: [fullName]),
            style: TextStyle(
              color: AppColors.typoHeading,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          // Previous Conversations Button
          GestureDetector(
            onTap: widget.onHistoryTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.lightPurple.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'chat.previous_conversations'.tr(),
                    style: TextStyle(
                      color: const Color(0xFF434B94),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    LucideIcons.history,
                    size: 16.r,
                    color: const Color(0xFF434B94),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 80.h),
          // Suggestions
          _buildSuggestionCard('chat.suggestion1'.tr()),
          _buildSuggestionCard('chat.suggestion2'.tr()),
          _buildSuggestionCard('chat.suggestion3'.tr()),
          SizedBox(height: 24.h),
          // Disclaimer
          Text(
            'chat.disclaimer'.tr(),
            style: TextStyle(
              color: AppColors.typoBody.withValues(alpha: 0.6),
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String text) {
    return GestureDetector(
      onTap: () => widget.onSuggestionTap(text),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.h),
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
