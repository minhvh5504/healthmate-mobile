import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

class PrescriptionSkeleton extends StatelessWidget {
  const PrescriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 16.h),

        // Section title
        _SkeletonBlock(width: 180.w, height: 20.h),
        SizedBox(height: 6.h),
        _SkeletonBlock(width: 220.w, height: 13.h),
        SizedBox(height: 16.h),

        // Active cards
        ...List.generate(
          2,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: const PrescriptionActiveCardSkeleton().animate().fadeIn(
              duration: 220.ms,
              delay: (60 * i).ms,
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // Info banner skeleton
        _SkeletonBlock(
          width: double.infinity,
          height: 50.h,
          borderRadius: BorderRadius.circular(12.r),
        ),

        SizedBox(height: 24.h),

        // History section title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SkeletonBlock(width: 160.w, height: 20.h),
            _SkeletonBlock(width: 70.w, height: 14.h),
          ],
        ),
        SizedBox(height: 12.h),

        // History items
        ...List.generate(
          3,
          (i) => Column(
            children: [
              const PrescriptionHistoryItemSkeleton().animate().fadeIn(
                duration: 220.ms,
                delay: (60 * i).ms,
              ),
              Divider(
                height: 1,
                color: AppColors.typoDisable.withValues(alpha: 0.15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrescriptionActiveCardSkeleton extends StatelessWidget {
  const PrescriptionActiveCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              _SkeletonBlock(
                width: 60.w,
                height: 72.h,
                borderRadius: BorderRadius.circular(10.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBlock(
                      width: 80.w,
                      height: 20.h,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    SizedBox(height: 8.h),
                    _SkeletonBlock(width: 140.w, height: 14.h),
                    SizedBox(height: 6.h),
                    _SkeletonBlock(width: 120.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            height: 1,
            color: AppColors.typoDisable.withValues(alpha: 0.15),
          ),
          SizedBox(height: 10.h),
          _SkeletonBlock(width: 200.w, height: 12.h),
          SizedBox(height: 6.h),
          _SkeletonBlock(width: 220.w, height: 12.h),
        ],
      ),
    );
  }
}

class PrescriptionHistoryItemSkeleton extends StatelessWidget {
  const PrescriptionHistoryItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          _SkeletonBlock(
            width: 48.w,
            height: 56.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(width: 160.w, height: 13.h),
                SizedBox(height: 6.h),
                _SkeletonBlock(width: 120.w, height: 12.h),
                SizedBox(height: 4.h),
                _SkeletonBlock(width: 100.w, height: 11.h),
              ],
            ),
          ),
          _SkeletonBlock(
            width: 16.w,
            height: 16.w,
            borderRadius: BorderRadius.circular(8.r),
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
