import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/history/history_provider.dart';

class HistoryCalendarCard extends ConsumerWidget {
  const HistoryCalendarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    return Container(
      padding: EdgeInsets.all(20.w),
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
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: state.focusedMonth,
        currentDay: DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(state.selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          notifier.selectDate(selectedDay);
          notifier.changeFocusedMonth(focusedDay);
        },
        onPageChanged: (focusedDay) {
          notifier.changeFocusedMonth(focusedDay);
        },
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: _buildChevron(Icons.chevron_left_rounded),
          rightChevronIcon: _buildChevron(Icons.chevron_right_rounded),
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBlack,
          ),
          leftChevronPadding: EdgeInsets.zero,
          rightChevronPadding: EdgeInsets.zero,
          headerPadding: EdgeInsets.only(bottom: 16.h),
        ),
        daysOfWeekHeight: 24.h,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: _dayOfWeekStyle(),
          weekendStyle: _dayOfWeekStyle(),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: EdgeInsets.all(6.w),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: AppColors.activeGradient,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          todayBuilder: (context, date, events) => Container(
            margin: EdgeInsets.all(6.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bgDisable, width: 1.w),
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          defaultBuilder: (context, date, events) => Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          outsideBuilder: (context, date, events) => Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoDisable,
              ),
            ),
          ),
          markerBuilder: (context, date, events) {
            final dayLogs = state.monthlyLogs.where((l) {
              return isSameDay(l.createdAt, date);
            }).toList();

            if (dayLogs.isEmpty) return null;

            final hasTaken = dayLogs.any((l) => l.isTaken);
            final hasMissed = dayLogs.any((l) => l.isMissed);

            return Positioned(
              bottom: 4.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTaken)
                    Container(
                      width: 4.w,
                      height: 4.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.bgSuccess,
                      ),
                    ),
                  if (hasMissed)
                    Container(
                      width: 4.w,
                      height: 4.w,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.bgError,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChevron(IconData icon) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: const BoxDecoration(
        gradient: AppColors.activeGradient,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.white, size: 20.sp),
    );
  }

  TextStyle _dayOfWeekStyle() {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.typoBody,
    );
  }
}
