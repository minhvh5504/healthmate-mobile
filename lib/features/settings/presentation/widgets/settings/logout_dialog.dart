import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class LogoutDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoBlack,
              ),
            ),

            SizedBox(height: 10.h),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: AppColors.typoBody,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 28.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: cancelText,
                    bgColor: AppColors.typoWhite,
                    borderColor: AppColors.typoDisable.withOpacity(0.4),
                    textColor: AppColors.typoBlack,
                    onTap: onCancel,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DialogButton(
                    label: confirmText,
                    bgColor: AppColors.typoBlack,
                    textColor: AppColors.typoWhite,
                    onTap: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Private button

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
