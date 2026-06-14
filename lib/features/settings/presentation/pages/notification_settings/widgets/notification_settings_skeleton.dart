import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

class NotificationSettingsSkeleton extends StatelessWidget {
  const NotificationSettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          // Section Header Skeleton
          Row(
            children: [
              _SkeletonBlock(
                width: 20.w,
                height: 20.w,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(width: 8.w),
              _SkeletonBlock(width: 180.w, height: 18.h),
            ],
          ).animate().fadeIn(duration: 220.ms),

          SizedBox(height: 8.h),

          // Description Skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonBlock(width: 260.w, height: 12.h),
              SizedBox(height: 6.h),
              _SkeletonBlock(width: 180.w, height: 12.h),
            ],
          ).animate().fadeIn(duration: 220.ms, delay: 50.ms),

          SizedBox(height: 16.h),

          // Cards Skeleton
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      _SkeletonBlock(
                        width: 44.w,
                        height: 44.w,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      SizedBox(width: 16.w),
                      _SkeletonBlock(width: 120.w, height: 15.h),
                      const Spacer(),
                      _SkeletonBlock(
                        width: 54.w,
                        height: 28.h,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                      duration: 220.ms,
                      delay: (100 + 50 * index).ms,
                    ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    const baseColor = AppColors.bgHover;
    const highlightColor = Colors.white;
    final radius = borderRadius ?? BorderRadius.circular(6.r);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor, borderRadius: radius),
      ),
    );
  }
}
