import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class UserCardSkeleton extends StatelessWidget {
  const UserCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgHover,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 120.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.bgHover,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 160.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: AppColors.bgHover,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ],
    );
  }
}
