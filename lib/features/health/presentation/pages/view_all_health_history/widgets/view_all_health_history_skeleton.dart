import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAllHealthHistorySkeleton extends StatelessWidget {
  const ViewAllHealthHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const _HealthHistoryItemSkeleton().animate().fadeIn(
          duration: 220.ms,
          delay: (60 * index).ms,
        );
      },
    );
  }
}

class _HealthHistoryItemSkeleton extends StatelessWidget {
  const _HealthHistoryItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 44.w, height: 44.w, radius: 22.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 120.w, height: 14.h, radius: 7.r),
                SizedBox(height: 10.h),
                _SkeletonBox(width: 180.w, height: 12.h, radius: 6.r),
              ],
            ),
          ),
          _SkeletonBox(width: 58.w, height: 24.h, radius: 12.r),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
