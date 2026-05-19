import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/app_colors.dart';

/// Full-page skeleton placeholder shown while History data is loading.
/// Mirrors the real layout: page title + adherence card + calendar card +
/// daily log list.
class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          _SkeletonBlock(
            width: 200.w,
            height: 28.h,
          ).animate().fadeIn(duration: 220.ms),
          SizedBox(height: 24.h),
          const _AdherenceCardSkeleton().animate().fadeIn(
            duration: 220.ms,
            delay: 60.ms,
          ),
          SizedBox(height: 24.h),
          const _CalendarCardSkeleton().animate().fadeIn(
            duration: 220.ms,
            delay: 120.ms,
          ),
          SizedBox(height: 24.h),
          _SkeletonBlock(
            width: 220.w,
            height: 22.h,
          ).animate().fadeIn(duration: 220.ms, delay: 180.ms),
          SizedBox(height: 16.h),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: const _LogCardSkeleton().animate().fadeIn(
                duration: 220.ms,
                delay: (240 + 60 * index).ms,
              ),
            ),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}

class _AdherenceCardSkeleton extends StatelessWidget {
  const _AdherenceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          _SkeletonBlock(
            width: 72.w,
            height: 72.w,
            borderRadius: BorderRadius.circular(36.r),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SkeletonBlock(width: 140.w, height: 14.h),
                SizedBox(height: 8.h),
                _SkeletonBlock(width: 180.w, height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCardSkeleton extends StatelessWidget {
  const _CalendarCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // Header (chevron - title - chevron)
          Row(
            children: [
              _SkeletonBlock(
                width: 28.w,
                height: 28.w,
                borderRadius: BorderRadius.circular(14.r),
              ),
              const Spacer(),
              _SkeletonBlock(width: 140.w, height: 18.h),
              const Spacer(),
              _SkeletonBlock(
                width: 28.w,
                height: 28.w,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Days of week row
          Row(
            children: List.generate(
              7,
              (i) => Expanded(
                child: Center(
                  child: _SkeletonBlock(width: 22.w, height: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // 5 calendar rows
          ...List.generate(
            5,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: List.generate(
                  7,
                  (i) => Expanded(
                    child: Center(
                      child: _SkeletonBlock(
                        width: 28.w,
                        height: 28.w,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogCardSkeleton extends StatelessWidget {
  const _LogCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _SkeletonBlock(
            width: 56.w,
            height: 56.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SkeletonBlock(width: 160.w, height: 14.h),
                SizedBox(height: 8.h),
                _SkeletonBlock(width: 110.w, height: 12.h),
                SizedBox(height: 6.h),
                _SkeletonBlock(width: 140.w, height: 12.h),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _SkeletonBlock(
            width: 24.w,
            height: 24.w,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(24.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
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
