import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../utils/helper.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
    required this.onPressed,
    this.height,
    this.width,
  });

  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return Container(
      width: width ?? (getWidth(context) - 16 - 16),
      height: height ?? 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: (color ?? AppColors.typoBlack).withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.bgDisable
              : (color ?? AppColors.typoBlack),
          foregroundColor: textColor ?? AppColors.typoWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.typoWhite,
                letterSpacing: -0.2,
              ),
            ),

            // Icon
            if (icon != null) ...[SizedBox(width: 12.w), icon!],
          ],
        ),
      ),
    );
  }
}
