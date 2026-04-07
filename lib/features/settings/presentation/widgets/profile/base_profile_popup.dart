import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';

/// BASE DISMISSABLE POPUP CONTAINER
class BaseProfilePopup extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const BaseProfilePopup({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32), // Placeholder for balance
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.typoNavi,
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close_rounded),
                color: AppColors.typoBlack,
              ),
            ],
          ),

          child,

          SizedBox(height: 24.h),

          // Save Button
          Button(
            text: 'profile.save'.tr(),
            color: AppColors.typoNavi,
            onPressed: () {
              onSave();
              context.pop();
            },
            width: double.infinity,
            height: 48.h,
          ),
          // Handle keyboard padding
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
