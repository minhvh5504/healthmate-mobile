import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine_reminder_edit/medicine_reminder_edit_notifier.dart';
import '../../../providers/medicine_reminder_edit/medicine_reminder_edit_provider.dart';
import 'medicine_reminder_date_popup.dart';
import 'medicine_reminder_frequency_popup.dart';

class MedicineReminderInfoCard extends ConsumerWidget {
  const MedicineReminderInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderEditProvider);
    final notifier = ref.read(medicineReminderEditProvider.notifier);

    return Column(
      children: [
        _buildItem(
          context: context,
          icon: LucideIcons.history,
          label: 'medicine.reminder.start'.tr(),
          value: state.getStartDateText(),
          onTap: () {
            notifier.setFocusedDate(state.startDate);
            _showDatePicker(
              context: context,
              title: 'medicine.reminder.start'.tr(),
              isEndDate: false,
              onDateSelected: notifier.updateStartDate,
            );
          },
        ),
        _buildDivider(),
        _buildItem(
          context: context,
          icon: LucideIcons.clock,
          label: 'medicine.reminder.end'.tr(),
          value: state.getEndDateText(),
          onTap: () {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final defaultEndDate = today.isBefore(state.startDate)
                ? state.startDate
                : today;
            notifier.setFocusedDate(state.endDate ?? defaultEndDate);
            _showDatePicker(
              context: context,
              title: 'medicine.reminder.end'.tr(),
              isEndDate: true,
              onDateSelected: notifier.updateEndDate,
            );
          },
        ),
        _buildDivider(),
        _buildItem(
          context: context,
          icon: LucideIcons.refreshCcw,
          label: 'medicine.reminder.frequency'.tr(),
          value: notifier.getFrequencyText(),
          onTap: () {
            _showFrequencyPicker(
              context: context,
              state: state,
              onSave: notifier.updateFrequencyAndDays,
            );
          },
        ),
        if (state.frequency != 'as_needed') _buildDivider(),
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF64748B), size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              LucideIcons.chevronRight,
              color: const Color(0xFFCBD5E1),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9));
  }

  void _showDatePicker({
    required BuildContext context,
    required String title,
    bool isEndDate = false,
    required Function(DateTime) onDateSelected,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Date Picker',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineReminderDatePopup(
                  title: title,
                  isEndDate: isEndDate,
                  onDateSelected: onDateSelected,
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
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _showFrequencyPicker({
    required BuildContext context,
    required MedicineReminderEditState state,
    required Function(String, List<int>) onSave,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Frequency Picker',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineReminderFrequencyPopup(
                  initialFrequency: state.frequency,
                  initialSelectedDays: state.selectedDays,
                  onSave: onSave,
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
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
