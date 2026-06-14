import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;

  const NotificationSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 24.w, 8.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.typoNavi.withValues(alpha: 0.42),
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Divider(color: AppColors.typoNavi.withValues(alpha: 0.12)),
          ),
        ],
      ),
    );
  }
}
