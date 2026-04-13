import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.borderColor,
  });

  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return Container(
      width: width ?? (getWidth(context) - 16 - 16),
      height: height ?? 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color:
                      (color == AppColors.bgWhite
                              ? AppColors.typoBlack
                              : (color ?? AppColors.typoBlack))
                          .withValues(alpha: 0.15),
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
            borderRadius: BorderRadius.circular(28.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (icon != null) ...[icon!, SizedBox(width: 8.w)],

            // Title
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.typoWhite,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
