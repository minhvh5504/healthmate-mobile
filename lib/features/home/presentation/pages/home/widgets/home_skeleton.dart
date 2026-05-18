import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE2E8F0),
            highlightColor: const Color(0xFFF8FAFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HomeHeaderSkeleton(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 92.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonLine(width: 150.w, height: 24.h),
                        SizedBox(height: 18.h),
                        const _ShortcutSkeletonGrid(),
                        SizedBox(height: 14.h),
                        const _MedicineSectionHeaderSkeleton(),
                        SizedBox(height: 12.h),
                        const MedicineScheduleSkeleton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineScheduleSkeleton extends StatelessWidget {
  const MedicineScheduleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Column(
        children: List.generate(
          2,
          (_) => const _MedicineReminderCardSkeleton(),
        ),
      ),
    );
  }
}

class _HomeHeaderSkeleton extends StatelessWidget {
  const _HomeHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      child: Row(
        children: [
          _SkeletonBox(width: 52.w, height: 52.w, borderRadius: 999.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SkeletonLine(width: 148.w, height: 13.h),
                SizedBox(height: 8.h),
                _SkeletonBox(width: 118.w, height: 24.h, borderRadius: 999.r),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _SkeletonBox(width: 40.w, height: 40.w, borderRadius: 999.r),
        ],
      ),
    );
  }
}

class _ShortcutSkeletonGrid extends StatelessWidget {
  const _ShortcutSkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _ShortcutCardSkeleton()),
        SizedBox(width: 14.w),
        const Expanded(child: _ShortcutCardSkeleton()),
      ],
    );
  }
}

class _ShortcutCardSkeleton extends StatelessWidget {
  const _ShortcutCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 116.h),
      padding: EdgeInsets.fromLTRB(10.w, 14.h, 10.w, 13.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7280).withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonBox(width: 54.w, height: 54.w, borderRadius: 999.r),
          SizedBox(height: 10.h),
          _SkeletonLine(width: 92.w, height: 13.h),
          SizedBox(height: 7.h),
          _SkeletonLine(width: 118.w, height: 11.h),
          SizedBox(height: 5.h),
          _SkeletonLine(width: 86.w, height: 11.h),
        ],
      ),
    );
  }
}

class _MedicineSectionHeaderSkeleton extends StatelessWidget {
  const _MedicineSectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SkeletonLine(width: 150.w, height: 24.h),
        ),
        _SkeletonBox(width: 86.w, height: 28.h, borderRadius: 999.r),
      ],
    );
  }
}

class _MedicineReminderCardSkeleton extends StatelessWidget {
  const _MedicineReminderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 10.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7280).withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 52.w, height: 52.w, borderRadius: 12.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 140.w, height: 14.h),
                SizedBox(height: 8.h),
                _SkeletonLine(width: 180.w, height: 10.h),
                SizedBox(height: 6.h),
                _SkeletonLine(width: 100.w, height: 10.h),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _SkeletonBox(width: 16.w, height: 16.w, borderRadius: 999.r),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const _SkeletonLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(width: width, height: height, borderRadius: 6.r);
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
