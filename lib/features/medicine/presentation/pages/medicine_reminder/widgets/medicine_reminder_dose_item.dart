import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/theme/app_colors.dart';

class MedicineReminderDoseItem extends StatelessWidget {
  final String time;
  final int dose;
  final VoidCallback onDelete;
  final VoidCallback onTimeTap;

  const MedicineReminderDoseItem({
    super.key,
    required this.time,
    required this.dose,
    required this.onDelete,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          SizedBox(
            width: 32.w,
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(8.r),
              child: Icon(
                LucideIcons.trash2,
                color: AppColors.typoDisable,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: InkWell(
              onTap: onTimeTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$time • $dose ${'medicine.reminder.doses_count'.tr()}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      color: const Color(0xFFCBD5E1),
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
