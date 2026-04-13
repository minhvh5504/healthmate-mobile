import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class ButtonDialog extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isDisabled;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final double? width;
  const ButtonDialog({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.height = 40,
    this.borderRadius = 14,
    this.width = 110,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isPrimary
        ? (color ?? AppColors.bgPrimary)
        : Colors.white;

    final Color borderColor = isPrimary
        ? Colors.transparent
        : AppColors.bgDisable.withValues(alpha: 0.4);

    final Color txtColor =
        textColor ?? (isPrimary ? AppColors.typoWhite : AppColors.typoBody);

    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          width: width?.w,
          height: height.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
        ),
      ),
    );
  }
}
