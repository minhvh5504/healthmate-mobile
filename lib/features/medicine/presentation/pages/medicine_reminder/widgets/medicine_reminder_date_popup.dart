import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';

class MedicineReminderDatePopup extends ConsumerWidget {
  final String title;
  final bool isEndDate;
  final Function(DateTime) onDateSelected;

  const MedicineReminderDatePopup({
    super.key,
    required this.title,
    this.isEndDate = false,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final notifier = ref.read(medicineReminderProvider.notifier);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isEndDate) ...[
                      _buildToggleSection(state, notifier),
                      SizedBox(height: 16.h),
                    ],
                    Opacity(
                      opacity: (isEndDate && !state.isEndDateEnabled) ? 0.3 : 1.0,
                      child: IgnorePointer(
                        ignoring: isEndDate && !state.isEndDateEnabled,
                        child: _buildCalendar(state, notifier, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        Positioned(
          top: 12.h,
          right: 12.w,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              LucideIcons.x,
              color: const Color(0xFF94A3B8),
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSection(dynamic state, dynamic notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            Switch(
              value: state.isEndDateEnabled,
              onChanged: (val) => notifier.toggleEndDateEnabled(val),
              activeThumbColor: const Color(0xFF22C55E),
              activeTrackColor: const Color(0xFF22C55E).withValues(alpha: 0.2),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'medicine.reminder.date_popup_message'.tr(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar(dynamic state, dynamic notifier, BuildContext context) {
    final selectedDate = isEndDate
        ? (state.endDate ?? state.startDate)
        : state.startDate;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstDay = isEndDate ? state.startDate : today;
    final lastDay = today.add(const Duration(days: 365 * 10));

    // Ensure focusedDay is within range [firstDay, lastDay]
    DateTime focusedDay = state.focusedDate;
    if (focusedDay.isBefore(firstDay)) {
      focusedDay = firstDay;
    } else if (focusedDay.isAfter(lastDay)) {
      focusedDay = lastDay;
    }

    return TableCalendar(
      locale: context.locale.toString(),
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        onDateSelected(selectedDay);
        Navigator.pop(context);
      },
      onPageChanged: (focusedDay) {
        notifier.setFocusedDate(focusedDay);
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: AppColors.activeGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) =>
            'medicine.reminder.month_year_format'.tr(
              args: [date.month.toString(), date.year.toString()],
            ),
        titleTextStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1E293B),
        ),
        leftChevronIcon: Icon(
          LucideIcons.chevronLeft,
          color: const Color(0xFF94A3B8),
          size: 20.sp,
        ),
        rightChevronIcon: Icon(
          LucideIcons.chevronRight,
          color: const Color(0xFF94A3B8),
          size: 20.sp,
        ),
        headerPadding: EdgeInsets.zero,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
        ),
        weekendStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
        ),
        dowTextFormatter: (date, locale) {
          final weekdays = [
            'medicine.reminder.days_full.sun'.tr(),
            'medicine.reminder.days_full.mon'.tr(),
            'medicine.reminder.days_full.tue'.tr(),
            'medicine.reminder.days_full.wed'.tr(),
            'medicine.reminder.days_full.thu'.tr(),
            'medicine.reminder.days_full.fri'.tr(),
            'medicine.reminder.days_full.sat'.tr(),
          ];
          return weekdays[date.weekday % 7];
        },
      ),
      calendarStyle: CalendarStyle(
        cellMargin: EdgeInsets.all(8.w),
        todayDecoration: const BoxDecoration(shape: BoxShape.circle),
        todayTextStyle: const TextStyle(
          color: AppColors.typoPrimary,
          fontWeight: FontWeight.w800,
        ),
        defaultTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        weekendTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        outsideTextStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}
