import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../providers/medicine_reminder_edit/medicine_reminder_edit_provider.dart';

class MedicineReminderToggleCard extends ConsumerWidget {
  const MedicineReminderToggleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderEditProvider);
    final notifier = ref.read(medicineReminderEditProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(LucideIcons.bell, color: const Color(0xFF64748B), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'medicine.reminder.medicine_reminder'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  state.reminderEnabled ? 'medicine.reminder.on'.tr() : 'medicine.reminder.off'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: state.reminderEnabled,
            onChanged: notifier.toggleReminder,
            activeTrackColor: const Color(0xFF22C55E),
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
