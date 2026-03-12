import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../button/button.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String? buttonText;
  final VoidCallback onTap;

  const ConfirmDialog({
    super.key,
    this.title,
    required this.message,
    this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title ?? 'dialog.error_title'.tr();
    final effectiveButtonText = buttonText ?? 'dialog.back'.tr();
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 35.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SVG Icon
            SvgPicture.asset(
              'assets/icons/popup/error_email.svg',
              width: 90.w,
              height: 90.w,
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              effectiveTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoBlack,
              ),
            ),
            SizedBox(height: 8.h),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: AppColors.typoBody.withOpacity(0.8),
                height: 1.5,
              ),
            ),

            SizedBox(height: 20.h),

            // Bottom Button
            Button(
              text: effectiveButtonText,
              height: 40.h,
              width: double.infinity,
              onPressed: () {
                context.pop();
                onTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
