import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';

class HealthHistorySummary extends StatelessWidget {
  final double? value;
  final String unit;
  final VoidCallback onHistoryTap;

  const HealthHistorySummary({
    super.key,
    required this.value,
    required this.unit,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'health.current_label'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: const Color(0xFF7B7790),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value == null ? '--' : _formatValue(value!),
                    style: TextStyle(
                      fontSize: 36.sp,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF666083),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onHistoryTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderPurple, width: 1.2),
              borderRadius: BorderRadius.circular(24.r),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.history,
                  size: 21.sp,
                  color: const Color(0xFF1D1730),
                ),
                SizedBox(width: 10.w),
                Text(
                  'health.history_button'.tr(),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1D1730),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  LucideIcons.chevronRight,
                  size: 22.sp,
                  color: const Color(0xFF7B7790),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }
}
