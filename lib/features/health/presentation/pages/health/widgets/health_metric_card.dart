import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String currentValue;
  final String unit;
  final String difference;
  final VoidCallback? onTap;

  const HealthMetricCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.currentValue,
    required this.unit,
    required this.difference,
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
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      title.contains('Cân Nặng') || title.contains('Weight')
                          ? LucideIcons.scale
                          : LucideIcons.flame,
                      size: 32.sp,
                      color: const Color(0xFFB0C4DE),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.typoBlack,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'health.today'.tr(),
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
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    currentValue,
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.typoBlack,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  unit,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.typoBody.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'health.days_ago'.tr(),
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
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    difference,
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.typoBlack,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  unit,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.typoBody.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
