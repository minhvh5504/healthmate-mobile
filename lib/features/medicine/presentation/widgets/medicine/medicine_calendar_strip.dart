import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

import 'dart:math' as math;

class MedicineCalendarStrip extends StatefulWidget {
  const MedicineCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<MedicineCalendarStrip> createState() => _MedicineCalendarStripState();
}

class _MedicineCalendarStripState extends State<MedicineCalendarStrip> {
  late final ScrollController _scrollController;
  late final DateTime _startDate;
  late final List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startDate = DateTime(today.year, today.month, today.day - 90);
    _days = List.generate(
      181,
      (i) => DateTime(_startDate.year, _startDate.month, _startDate.day + i),
    );

    final initialIndex = _indexOfDate(widget.selectedDate);
    final initialOffset = _getOffset(initialIndex);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void didUpdateWidget(covariant MedicineCalendarStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      final idx = _indexOfDate(widget.selectedDate);
      _scrollToIndex(idx);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _indexOfDate(DateTime date) {
    final utcStartDate = DateTime.utc(
      _startDate.year,
      _startDate.month,
      _startDate.day,
    );
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    final diff = utcDate.difference(utcStartDate).inDays;
    return diff.clamp(0, _days.length - 1);
  }

  double _getOffset(int index) {
    final itemWidth = 50.w;
    final spacing = 8.w;
    final paddingLeft = 12.w;
    final screenWidth = 1.sw;

    final centerOffset =
        paddingLeft +
        (index * (itemWidth + spacing)) -
        (screenWidth / 2) +
        (itemWidth / 2);
    return math.max(0.0, centerOffset);
  }

  void _scrollToIndex(int index) {
    final target = _getOffset(index);
    if (_scrollController.hasClients) {
      final maxExtent = _scrollController.position.maxScrollExtent;
      final clampedTarget = math.max(0.0, math.min(target, maxExtent));
      _scrollController.animateTo(
        clampedTarget,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemCount: _days.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final day = _days[index];
          final isSelected = _isSameDay(day, widget.selectedDate);
          final isToday = _isSameDay(day, DateTime.now());

          return _DayCell(
            day: day,
            isSelected: isSelected,
            isToday: isToday,
            onTap: () {
              widget.onDateSelected(day);
              _scrollToIndex(index);
            },
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final weekdayLabel = _weekdayShort(day.weekday);
    final dayLabel = day.day.toString();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdayLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.typoBlack
                    : const Color(0xFF8F9BB3),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF13172E)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                dayLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.typoHeading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayShort(int weekday) {
    const labels = {
      1: 'TH 2',
      2: 'TH 3',
      3: 'TH 4',
      4: 'TH 5',
      5: 'TH 6',
      6: 'TH 7',
      7: 'CN',
    };
    return labels[weekday] ?? '';
  }
}
