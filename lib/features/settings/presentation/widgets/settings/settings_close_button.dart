import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SettingsCloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const SettingsCloseButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, top: 8.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50.r),
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.close_rounded,
              size: 18.sp,
              color: AppColors.typoBlack,
            ),
          ),
        ),
      ),
    );
  }
}
