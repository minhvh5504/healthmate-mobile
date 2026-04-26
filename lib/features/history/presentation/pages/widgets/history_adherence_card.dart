import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class HistoryAdherenceCard extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final DateTime focusedMonth;

  const HistoryAdherenceCard({
    super.key,
    required this.percentage,
    required this.focusedMonth,
  });

  @override
  Widget build(BuildContext context) {
    // e.g. "tháng 3 năm 2026"
    final String monthYearStr = 'medicine.reminder.month_year_format'.tr(
      args: [focusedMonth.month.toString(), focusedMonth.year.toString()],
    );
    final int percentInt = (percentage * 100).round();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 72.w,
            height: 72.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 6.w,
                  backgroundColor: AppColors.bgHover,
                  color: AppColors.bgPrimary,
                ),
                Center(
                  child: Text(
                    '$percentInt%',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'history.monthly_adherence'.tr(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.typoBody,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  monthYearStr,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
