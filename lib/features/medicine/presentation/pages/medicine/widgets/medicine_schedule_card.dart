import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/daily_schedule_item.dart';
import 'medicine_logged_popup.dart';
import 'medicine_schedule_popup.dart';

class MedicineScheduleCard extends StatelessWidget {
  final DailyScheduleItem item;
  final VoidCallback? onTap;
  final bool canLogMedication;

  const MedicineScheduleCard({
    super.key,
    required this.item,
    this.onTap,
    this.canLogMedication = true,
  });

  @override
  Widget build(BuildContext context) {
    final status = item.status.toLowerCase();
    final isTaken = status == 'taken';
    final isMissed = status == 'missed';

    Color borderColor = Colors.transparent;
    if (isTaken) borderColor = AppColors.bgSuccess;
    if (isMissed) borderColor = AppColors.typoError;

    return GestureDetector(
      onTap: canLogMedication
          ? (onTap ??
                () {
                  if (status != 'pending') {
                    MedicineLoggedPopup.show(context, item);
                  } else {
                    final instruction = getMealInstructionText(
                      context,
                      item.mealInstruction,
                    );
                    MedicineSchedulePopup.show(context, item, instruction);
                  }
                })
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: borderColor, width: 1.5.w),
          boxShadow: [
            BoxShadow(
              color: borderColor == Colors.transparent
                  ? Colors.black.withValues(alpha: 0.04)
                  : borderColor.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF6B66FF),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B66FF).withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _getSectionIcon(item.remindTime),
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.medicationName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item.quantity ?? 1} ${'medicine.reminder.doses_count'.tr()}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoBody.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    getMealInstructionText(context, item.mealInstruction),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoBody.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            _buildTrailingWidget(status, canLogMedication),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(String? remindTime) {
    if (remindTime == null) return LucideIcons.calendar;
    final hour = int.tryParse(remindTime.split(':')[0]) ?? 0;
    if (hour < 12) return LucideIcons.sun;
    if (hour < 18) return LucideIcons.sunset;
    return LucideIcons.moon;
  }

  Widget _buildTrailingWidget(String status, bool canLogMedication) {
    if (status == 'taken') {
      return Container(
        width: 20.w,
        height: 20.w,
        decoration: const BoxDecoration(
          color: AppColors.bgSuccess,
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.check, color: Colors.white, size: 16.sp),
      );
    }
    if (status == 'missed') {
      return Container(
        width: 20.w,
        height: 20.w,
        decoration: const BoxDecoration(
          color: AppColors.typoError,
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.x, color: Colors.white, size: 16.sp),
      );
    }

    if (!canLogMedication) {
      return SizedBox(width: 20.w);
    }

    return Icon(
      LucideIcons.chevronRight,
      color: AppColors.typoBody.withValues(alpha: 0.3),
      size: 20.sp,
    );
  }

  String getMealInstructionText(BuildContext context, String? slug) {
    if (slug == null || slug.isEmpty) return '-';

    final key = 'medicine.instruction.$slug';
    final translated = key.tr();

    if (translated == key) {
      return slug;
    }
    return translated;
  }
}
