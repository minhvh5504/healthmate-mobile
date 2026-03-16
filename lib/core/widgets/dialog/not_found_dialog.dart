import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../button/button.dart';

class AccountNotFoundDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final String? iconPath;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const AccountNotFoundDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.iconPath,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 35.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Stack(
        children: [
          // Close button
          Positioned(
            right: 16.w,
            top: 16.h,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                Icons.close,
                color: AppColors.typoBody.withOpacity(0.5),
                size: 24.sp,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath ?? 'assets/icons/popup/error_email.svg',
                  width: 100.w,
                  height: 100.w,
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoBlack,
                  ),
                ),
                SizedBox(height: 12.h),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: AppColors.typoBody.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 32.h),

                // Primary button
                Button(
                  text: primaryButtonText,
                  height: 48.h,
                  width: double.infinity,
                  onPressed: () {
                    context.pop();
                    onPrimaryPressed();
                  },
                ),

                SizedBox(height: 12.h),

                // Secondary button
                Button(
                  text: secondaryButtonText,
                  height: 48.h,
                  width: double.infinity,
                  color: Colors.white,
                  textColor: AppColors.typoBlack,
                  borderColor: AppColors.bgDisable,
                  onPressed: () {
                    context.pop();
                    onSecondaryPressed();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
