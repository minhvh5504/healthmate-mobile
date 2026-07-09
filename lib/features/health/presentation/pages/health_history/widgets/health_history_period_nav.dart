import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HealthHistoryPeriodNav extends StatelessWidget {
  final HealthHistoryRange range;
  final DateTime cursorDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const HealthHistoryPeriodNav({
    super.key,
    required this.range,
    required this.cursorDate,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavButton(icon: LucideIcons.chevronLeft, onTap: onPrevious),
        Expanded(
          child: Text(
            _title(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1D1730),
            ),
          ),
        ),
        _NavButton(icon: LucideIcons.chevronRight, onTap: onNext),
      ],
    );
  }

  String _title() {
    switch (range) {
      case HealthHistoryRange.day:
        final today = DateTime.now();
        final isToday =
            cursorDate.year == today.year &&
            cursorDate.month == today.month &&
            cursorDate.day == today.day;
        return isToday
            ? 'health.period_today'.tr()
            : 'health.period_day_format'.tr(
                args: [cursorDate.month.toString(), cursorDate.day.toString()],
              );
      case HealthHistoryRange.week:
        final start = cursorDate.subtract(
          Duration(days: cursorDate.weekday - 1),
        );
        final end = start.add(const Duration(days: 6));

        final now = DateTime.now();
        final nowStart = now.subtract(Duration(days: now.weekday - 1));
        final isCurrentWeek =
            start.year == nowStart.year &&
            start.month == nowStart.month &&
            start.day == nowStart.day;

        return isCurrentWeek
            ? 'health.period_this_week'.tr()
            : 'health.period_week_format'.tr(
                args: [
                  start.month.toString(),
                  start.day.toString(),
                  end.day.toString(),
                ],
              );
      case HealthHistoryRange.month:
        final now = DateTime.now();
        final isCurrentMonth =
            cursorDate.year == now.year && cursorDate.month == now.month;
        return isCurrentMonth
            ? 'health.period_this_month'.tr()
            : 'health.period_month_format'.tr(
                args: [cursorDate.month.toString(), cursorDate.year.toString()],
              );
    }
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: const Color(0xFF1D1730),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
