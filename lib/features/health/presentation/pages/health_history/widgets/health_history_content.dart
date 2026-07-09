import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_chart.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_header.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_period_nav.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_range_tabs.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_summary.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';

class HealthHistoryContent extends StatelessWidget {
  final String title;
  final String unit;
  final HealthHistoryMetric metric;
  final HealthHistoryRange range;
  final DateTime cursorDate;
  final List<HealthHistoryEntry> entries;
  final double? currentValue;
  final ValueChanged<HealthHistoryRange> onRangeChanged;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;
  final VoidCallback onHistoryTap;

  const HealthHistoryContent({
    super.key,
    required this.title,
    required this.unit,
    required this.metric,
    required this.range,
    required this.cursorDate,
    required this.entries,
    required this.currentValue,
    required this.onRangeChanged,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthHistoryHeader(title: title),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HealthHistoryRangeTabs(
              selectedRange: range,
              onChanged: onRangeChanged,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HealthHistoryPeriodNav(
              range: range,
              cursorDate: cursorDate,
              onPrevious: onPreviousPeriod,
              onNext: onNextPeriod,
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HealthHistorySummary(
              value: currentValue,
              unit: unit,
              onHistoryTap: onHistoryTap,
            ),
          ),
          SizedBox(height: 24.h),
          HealthHistoryChart(
            metric: metric,
            range: range,
            cursorDate: cursorDate,
            entries: entries,
            currentValue: currentValue,
            unit: unit,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
