import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

import '../../providers/history/history_provider.dart';
import 'history_log_card.dart';

class HistoryLogList extends ConsumerWidget {
  const HistoryLogList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final logs = state.dailyLogs;

    final weekdayKey = _getWeekdayKey(state.selectedDate.weekday);
    final monthShort = 'history.month_short.${state.selectedDate.month}'.tr();
    final dateStr = 'history.date_format'.tr(
      args: [weekdayKey.tr(), state.selectedDate.day.toString(), monthShort],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          dateStr,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBlack,
          ),
        ),
        SizedBox(height: 16.h),
        if (logs.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                'history.no_data'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  color: AppColors.typoDisable,
                ),
              ),
            ),
          )
        else
          ...logs.map((log) => HistoryLogCard(log: log)),
      ],
    );
  }

  String _getWeekdayKey(int weekday) {
    switch (weekday) {
      case 1:
        return 'medicine.reminder.days_full.mon';
      case 2:
        return 'medicine.reminder.days_full.tue';
      case 3:
        return 'medicine.reminder.days_full.wed';
      case 4:
        return 'medicine.reminder.days_full.thu';
      case 5:
        return 'medicine.reminder.days_full.fri';
      case 6:
        return 'medicine.reminder.days_full.sat';
      case 7:
        return 'medicine.reminder.days_full.sun';
      default:
        return '';
    }
  }
}
