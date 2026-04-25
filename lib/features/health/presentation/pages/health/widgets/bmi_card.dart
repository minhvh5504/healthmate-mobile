import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BMICard extends StatelessWidget {
  final double bmi;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const BMICard({
    super.key,
    required this.bmi,
    required this.status,
    this.statusColor = const Color(0xFF34C759),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.barChart2,
                      size: 32.sp,
                      color: AppColors.typoHeading,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'health.calculate_bmi'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.typoHeading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'health.current_index'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.typoBody.withValues(alpha: 0.4),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              bmi > 0 ? bmi.toStringAsFixed(1) : '—',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.typoHeading,
                                height: 1,
                              ),
                            ),
                            if (bmi > 0) ...[
                              SizedBox(width: 4.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  'kg/m²',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.typoBody.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'health.classification'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.typoBody.withValues(alpha: 0.4),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // BMI Scale Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    final fullWidth = constraints.maxWidth;
                    final markerPosition = _calculateMarkerPosition(fullWidth);

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            _buildBarSegment(
                              const Color(0xFF3ABEF9),
                            ), // Underweight
                            SizedBox(width: 4.w),
                            _buildBarSegment(const Color(0xFF50E38B)), // Normal
                            SizedBox(width: 4.w),
                            _buildBarSegment(
                              const Color(0xFFFFD620),
                            ), // Overweight
                            SizedBox(width: 4.w),
                            _buildBarSegment(const Color(0xFFFF7E8E)), // Obese
                          ],
                        ),
                        // Marker
                        if (bmi > 0)
                          Positioned(
                            left: markerPosition - 15.w,
                            bottom: -28.h,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up,
                                  size: 18.sp,
                                  color: AppColors.typoHeading,
                                ),
                                Text(
                                  'health.you'.tr(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.typoHeading,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMarkerPosition(double totalWidth) {
    if (bmi <= 0) return 0;

    double percentage = 0;
    if (bmi < 18.5) {
      percentage = (bmi / 18.5) * 0.25;
    } else if (bmi < 25) {
      percentage = 0.25 + ((bmi - 18.5) / (25 - 18.5)) * 0.25;
    } else if (bmi < 30) {
      percentage = 0.5 + ((bmi - 25) / (30 - 25)) * 0.25;
    } else {
      percentage = 0.75 + ((bmi - 30) / 10).clamp(0, 1) * 0.25;
    }

    return totalWidth * percentage;
  }

  Widget _buildBarSegment(Color color) {
    return Expanded(
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
