import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/header/app_header.dart';

/// Skeleton placeholder shown while Health profile is loading.
class HealthSkeleton extends StatelessWidget {
  const HealthSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: const Color(0xFFE2E8F0),
                  highlightColor: const Color(0xFFF8FAFC),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          child: _SkeletonLine(width: 220.w, height: 28.h),
                        ),
                        SizedBox(height: 8.h),
                        const _MetricCardSkeleton(),
                        SizedBox(height: 8.h),
                        const _MetricCardSkeleton(),
                        SizedBox(height: 8.h),
                        const _BMICardSkeleton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCardSkeleton extends StatelessWidget {
  const _MetricCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 32.w, height: 32.w, borderRadius: 8.r),
              SizedBox(width: 12.w),
              _SkeletonLine(width: 120.w, height: 22.h),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                flex: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: 60.w, height: 10.h),
                    SizedBox(height: 8.h),
                    _SkeletonLine(width: 90.w, height: 32.h),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: 90.w, height: 10.h),
                    SizedBox(height: 8.h),
                    _SkeletonLine(width: 80.w, height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BMICardSkeleton extends StatelessWidget {
  const _BMICardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonBox(width: 32.w, height: 32.w, borderRadius: 8.r),
              SizedBox(width: 12.w),
              _SkeletonLine(width: 110.w, height: 22.h),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonLine(width: 100.w, height: 10.h),
                  SizedBox(height: 8.h),
                  _SkeletonLine(width: 110.w, height: 32.h),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SkeletonLine(width: 60.w, height: 10.h),
                  SizedBox(height: 8.h),
                  _SkeletonLine(width: 90.w, height: 22.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 3 ? 0 : 4.w),
                  child: _SkeletonBox(
                    width: double.infinity,
                    height: 12.h,
                    borderRadius: 10.r,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
    border: Border.all(color: const Color(0xFFF1F1F1)),
  );
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
