import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';

/// Skeleton placeholder shown while Medicine data is loading.
class MedicineSkeleton extends StatelessWidget {
  const MedicineSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: double.infinity, height: 72.h),
          SizedBox(height: 24.h),
          _SkeletonBox(width: 140.w, height: 16.h),
          SizedBox(height: 32.h),
          Center(
            child: _SkeletonBox(width: 160.w, height: 160.w),
          ),
          SizedBox(height: 24.h),
          _SkeletonBox(width: double.infinity, height: 14.h),
          SizedBox(height: 8.h),
          _SkeletonBox(width: 220.w, height: 14.h),
          SizedBox(height: 32.h),
          _SkeletonBox(width: double.infinity, height: 52.h),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgHover,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
