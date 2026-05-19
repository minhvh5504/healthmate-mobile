import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/app_colors.dart';

/// Full-page skeleton placeholder shown while Notifications are loading.
/// Mirrors the real layout: header (back + more) + page title + section
/// headers + notification cards.
class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderSkeleton().animate().fadeIn(duration: 220.ms),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _SkeletonBlock(
            width: 200.w,
            height: 28.h,
          ).animate().fadeIn(duration: 220.ms, delay: 60.ms),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(bottom: 24.h),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const _SectionHeaderSkeleton().animate().fadeIn(
                duration: 220.ms,
                delay: 120.ms,
              ),
              ...List.generate(
                3,
                (index) => const _NotificationCardSkeleton().animate().fadeIn(
                  duration: 220.ms,
                  delay: (180 + 60 * index).ms,
                ),
              ),
              SizedBox(height: 16.h),
              const _SectionHeaderSkeleton().animate().fadeIn(
                duration: 220.ms,
                delay: 360.ms,
              ),
              ...List.generate(
                2,
                (index) => const _NotificationCardSkeleton().animate().fadeIn(
                  duration: 220.ms,
                  delay: (420 + 60 * index).ms,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SkeletonBlock(
              width: 36.w,
              height: 36.w,
              borderRadius: BorderRadius.circular(18.r),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: _SkeletonBlock(
                width: 22.w,
                height: 22.w,
                borderRadius: BorderRadius.circular(11.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          _SkeletonBlock(width: 80.w, height: 14.h),
          SizedBox(width: 8.w),
          Expanded(
            child: _SkeletonBlock(width: double.infinity, height: 1.h),
          ),
        ],
      ),
    );
  }
}

class _NotificationCardSkeleton extends StatelessWidget {
  const _NotificationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBlock(
            width: 50.w,
            height: 50.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SkeletonBlock(width: 160.w, height: 16.h),
                    ),
                    SizedBox(width: 8.w),
                    _SkeletonBlock(width: 36.w, height: 12.h),
                    SizedBox(width: 8.w),
                    _SkeletonBlock(
                      width: 8.w,
                      height: 8.w,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _SkeletonBlock(width: double.infinity, height: 12.h),
                SizedBox(height: 6.h),
                _SkeletonBlock(width: 200.w, height: 12.h),
              ],
            ),
          ),
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
    final radius = borderRadius ?? BorderRadius.circular(8.r);

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
