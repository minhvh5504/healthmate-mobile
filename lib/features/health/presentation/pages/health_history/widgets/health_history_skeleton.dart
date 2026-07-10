import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton placeholder shown while health history data is loading.
class HealthHistorySkeleton extends StatelessWidget {
  const HealthHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: back button + title
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 0.h),
              child: SizedBox(
                height: 44.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _SkeletonBox(
                        width: 36.w,
                        height: 36.w,
                        borderRadius: 50.r,
                      ),
                    ),
                    _SkeletonLine(width: 100.w, height: 18.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFE2E8F0),
                highlightColor: const Color(0xFFF8FAFC),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Range tabs (day / week / month)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: _SkeletonBox(
                          width: double.infinity,
                          height: 40.h,
                          borderRadius: 12.r,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Period nav (prev / label / next)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            _SkeletonBox(
                              width: 36.w,
                              height: 36.w,
                              borderRadius: 50.r,
                            ),
                            const Spacer(),
                            _SkeletonLine(width: 100.w, height: 16.h),
                            const Spacer(),
                            _SkeletonBox(
                              width: 36.w,
                              height: 36.w,
                              borderRadius: 50.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Summary card (current value + history button)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SkeletonLine(width: 60.w, height: 11.h),
                                SizedBox(height: 6.h),
                                _SkeletonLine(width: 90.w, height: 36.h),
                              ],
                            ),
                            const Spacer(),
                            _SkeletonBox(
                              width: 120.w,
                              height: 38.h,
                              borderRadius: 50.r,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Chart area
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: _SkeletonBox(
                          width: double.infinity,
                          height: 330.h,
                          borderRadius: 12.r,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
