import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class ScanTipItem extends StatelessWidget {
  final Widget icon;
  final String text;

  const ScanTipItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconTheme(
              data: IconThemeData(color: AppColors.typoHeading, size: 20.sp),
              child: icon,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.typoBody,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
