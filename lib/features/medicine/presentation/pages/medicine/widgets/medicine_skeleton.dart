import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

/// Full-page skeleton placeholder shown while Medicine data is loading.
/// Mirrors the real layout: tab bar (lịch thuốc / hộp thuốc) + avatar +
/// calendar strip + date label + schedule cards.
class MedicineSkeleton extends StatelessWidget {
  const MedicineSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MedicineTabBarSkeleton(),
        SizedBox(height: 16.h),
        const _CalendarStripSkeleton(),
        SizedBox(height: 8.h),
        Center(
          child: _SkeletonBlock(width: 120.w, height: 14.h),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
            itemCount: 4,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) =>
                const MedicineScheduleCardSkeleton().animate().fadeIn(
                  duration: 220.ms,
                  delay: (60 * index).ms,
                ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton list reused for inline schedule loading (e.g. when changing day).
class MedicineScheduleListSkeleton extends StatelessWidget {
  const MedicineScheduleListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) => const MedicineScheduleCardSkeleton()
          .animate()
          .fadeIn(duration: 220.ms, delay: (60 * index).ms),
    );
  }
}

class _MedicineTabBarSkeleton extends StatelessWidget {
  const _MedicineTabBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SkeletonBlock(width: 96.w, height: 18.h),
              SizedBox(height: 6.h),
              _SkeletonBlock(
                width: 96.w,
                height: 3.h,
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SkeletonBlock(width: 88.w, height: 18.h),
              SizedBox(height: 6.h),
              _SkeletonBlock(
                width: 88.w,
                height: 3.h,
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SkeletonBlock(
                width: 40.w,
                height: 40.w,
                borderRadius: BorderRadius.circular(20.r),
              ),
              SizedBox(width: 4.w),
              _SkeletonBlock(
                width: 14.w,
                height: 14.w,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarStripSkeleton extends StatelessWidget {
  const _CalendarStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) => SizedBox(
          width: 50.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SkeletonBlock(width: 24.w, height: 11.h),
              SizedBox(height: 6.h),
              _SkeletonBlock(
                width: 32.w,
                height: 32.w,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicineScheduleCardSkeleton extends StatelessWidget {
  const MedicineScheduleCardSkeleton({super.key});

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
            width: 20.w,
            height: 20.w,
            borderRadius: BorderRadius.circular(10.r),
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
