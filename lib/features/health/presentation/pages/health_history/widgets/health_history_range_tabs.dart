import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';

class HealthHistoryRangeTabs extends StatelessWidget {
  final HealthHistoryRange selectedRange;
  final ValueChanged<HealthHistoryRange> onChanged;

  const HealthHistoryRangeTabs({
    super.key,
    required this.selectedRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.borderPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: HealthHistoryRange.values.map((range) {
          final isSelected = selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1D1730)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  _rangeLabel(range),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF1D1730),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _rangeLabel(HealthHistoryRange range) {
    switch (range) {
      case HealthHistoryRange.day:
        return 'health.range_day'.tr();
      case HealthHistoryRange.week:
        return 'health.range_week'.tr();
      case HealthHistoryRange.month:
        return 'health.range_month'.tr();
    }
  }
}
