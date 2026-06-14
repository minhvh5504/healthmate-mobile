import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine_reminder/medicine_reminder_notifier.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';
import 'medicine_reminder_dose_item.dart';
import 'medicine_reminder_quantity_popup.dart';
import 'medicine_reminder_time_popup.dart';

class MedicineReminderScheduleCard extends ConsumerWidget {
  const MedicineReminderScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final notifier = ref.read(medicineReminderProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.clock,
              color: const Color(0xFF64748B),
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'medicine.reminder.schedule'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.schedules.length,
          separatorBuilder: (context, index) => SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            final schedule = state.schedules[index];
            return MedicineReminderDoseItem(
              time: schedule.time,
              quantity: schedule.quantity,
              onDelete: () => notifier.removeSchedule(index),
              onTimeTap: () => _showTimePicker(
                context,
                notifier,
                index: index,
                initialTime: schedule.time,
                initialQuantity: schedule.quantity,
              ),
            );
          },
        ),
        SizedBox(height: 4.h),
        _buildAddDoseButton(context, notifier),
      ],
    );
  }

  void _showTimePicker(
    BuildContext context,
    MedicineReminderNotifier notifier, {
    required String initialTime,
    required int initialQuantity,
    int? index,
  }) {
    final parentContext = context;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Time Picker',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineReminderTimePopup(
                  initialTime: initialTime,
                  onSave: (newTime) {
                    Navigator.pop(context);
                    _showQuantityPicker(
                      parentContext,
                      notifier,
                      index: index,
                      time: newTime,
                      initialQuantity: initialQuantity,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _showQuantityPicker(
    BuildContext context,
    MedicineReminderNotifier notifier, {
    required String time,
    required int initialQuantity,
    int? index,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Quantity Picker',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineReminderQuantityPopup(
                  initialQuantity: initialQuantity,
                  onSave: (quantity) {
                    if (index == null) {
                      notifier.addSchedule(time, quantity);
                    } else {
                      notifier.updateSchedule(index, time, quantity);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildAddDoseButton(
    BuildContext context,
    MedicineReminderNotifier notifier,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        children: [
          SizedBox(
            width: 32.w,
            child: Icon(
              LucideIcons.plusCircle,
              color: AppColors.typoBlack,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: InkWell(
              onTap: () => _showTimePicker(
                context,
                notifier,
                initialTime: '08:00',
                initialQuantity: 1,
              ),
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
                        'medicine.reminder.add_dose'.tr(),
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
