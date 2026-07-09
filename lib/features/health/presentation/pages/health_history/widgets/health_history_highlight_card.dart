import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HealthHistoryHighlightCard extends StatelessWidget {
  final String metricName;

  const HealthHistoryHighlightCard({super.key, required this.metricName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1DEEA)),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D1730).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Text(
        metricName == 'BMI'
            ? 'health.history_bmi_highlight'.tr()
            : 'health.history_metric_highlight'.tr(args: [metricName]),
        style: TextStyle(
          fontSize: 18.sp,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF747182),
        ),
      ),
    );
  }
}
