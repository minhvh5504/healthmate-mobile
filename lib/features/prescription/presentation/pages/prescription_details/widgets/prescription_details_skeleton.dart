import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

class PrescriptionDetailsSkeleton extends StatelessWidget {
  const PrescriptionDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title and badge skeleton
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBlock(width: 140.w, height: 18.h),
                  _SkeletonBlock(width: 60.w, height: 22.h, borderRadius: BorderRadius.circular(18.r)),
                ],
              ),
              SizedBox(height: 18.h),
              
              // Image skeleton
              _SkeletonBlock(
                width: double.infinity,
                height: 188.h,
                borderRadius: BorderRadius.circular(10.r),
              ),
              SizedBox(height: 22.h),

              // Info rows skeletons
              ...List.generate(5, (i) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    _SkeletonBlock(width: 20.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonBlock(width: 80.w, height: 12.h),
                        SizedBox(height: 6.h),
                        _SkeletonBlock(width: 150.w, height: 14.h),
                      ],
                    ),
                  ],
                ),
              )),
              
              SizedBox(height: 4.h),

              // Action buttons skeletons
              Row(
                children: [
                  Expanded(child: _SkeletonBlock(height: 40.h, borderRadius: BorderRadius.circular(8.r))),
                  SizedBox(width: 12.w),
                  Expanded(child: _SkeletonBlock(height: 40.h, borderRadius: BorderRadius.circular(8.r))),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.03, end: 0, duration: 250.ms, curve: Curves.easeOut),
        
        SizedBox(height: 12.h),
        
        // Info banner skeleton
        _SkeletonBlock(
          width: double.infinity,
          height: 50.h,
          borderRadius: BorderRadius.circular(12.r),
        ).animate().fadeIn(duration: 250.ms, delay: 100.ms),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    this.width,
    required this.height,
    this.borderRadius,
  });

  final double? width;
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
