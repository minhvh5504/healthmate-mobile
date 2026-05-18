import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../medicine/domain/entities/daily_schedule.dart';
import '../../../../../medicine/domain/entities/daily_schedule_item.dart';
import 'home_skeleton.dart';

class HealthStatusSection extends StatelessWidget {
  final DailySchedule? schedule;
  final bool isLoading;
  final VoidCallback? onTap;

  const HealthStatusSection({
    super.key,
    this.schedule,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && schedule == null) {
      return const MedicineScheduleSkeleton();
    }

    final items = [
      ...?schedule?.morning,
      ...?schedule?.afternoon,
      ...?schedule?.evening,
    ]..sort((a, b) => (a.remindTime ?? '').compareTo(b.remindTime ?? ''));

    if (items.isEmpty) {
      return _MedicineTodayEmpty(onTap: onTap);
    }

    return Column(
      children: items.take(2).map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _MedicineReminderCard(item: item, onTap: onTap),
        );
      }).toList(),
    );
  }
}

class _MedicineReminderCard extends StatelessWidget {
  final DailyScheduleItem item;
  final VoidCallback? onTap;

  const _MedicineReminderCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final quantity = item.quantity ?? item.actualQuantity ?? 1;
    final time = item.remindTime;
    final instruction = _formatMealInstruction(item.mealInstruction);
    final subtitleParts = [
      if (time != null && time.isNotEmpty) time,
      'home.dose_count'.tr(args: [quantity.toString()]),
      if (instruction != null) instruction,
    ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 10.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B7280).withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.medicationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.typoBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitleParts.join('\n'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF9AA8C7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.18,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFC9D3E5),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  String? _formatMealInstruction(String? instruction) {
    return switch (instruction) {
      'before_breakfast' => 'home.meal_instruction.before_breakfast'.tr(),
      'after_breakfast' => 'home.meal_instruction.after_breakfast'.tr(),
      'before_lunch' => 'home.meal_instruction.before_lunch'.tr(),
      'after_lunch' => 'home.meal_instruction.after_lunch'.tr(),
      'before_dinner' => 'home.meal_instruction.before_dinner'.tr(),
      'after_dinner' => 'home.meal_instruction.after_dinner'.tr(),
      'before_sleep' => 'home.meal_instruction.before_sleep'.tr(),
      'between_meals' => 'home.meal_instruction.between_meals'.tr(),
      final value? when value.isNotEmpty => value,
      _ => null,
    };
  }
}

class _MedicineTodayEmpty extends StatelessWidget {
  final VoidCallback? onTap;

  const _MedicineTodayEmpty({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/home/not_found.png',
              width: 200.sp,
              height: 200.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),
            Text(
              'home.no_changes_today'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4338CA),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'home.update_to_track'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.typoBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
