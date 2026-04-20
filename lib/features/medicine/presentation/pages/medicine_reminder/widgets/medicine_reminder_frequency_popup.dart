import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine_reminder/medicine_reminder_notifier.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';

class MedicineReminderFrequencyPopup extends ConsumerWidget {
  const MedicineReminderFrequencyPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final notifier = ref.read(medicineReminderProvider.notifier);

    return Container(
      width: 0.9.sw,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          _buildOption(
            context,
            'daily',
            'medicine.reminder.daily'.tr(),
            state.frequency == 'daily',
            onTap: () => notifier.updateFrequency('daily'),
          ),
          _buildDivider(),
          _buildOption(
            context,
            'specific_days',
            'medicine.reminder.specific_days'.tr(),
            state.frequency == 'specific_days',
            onTap: () => notifier.updateFrequency('specific_days'),
            extra: state.frequency == 'specific_days'
                ? Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: _buildDaysSelection(state, notifier),
                  )
                : null,
          ),
          _buildDivider(),
          _buildOption(
            context,
            'as_needed',
            'medicine.reminder.as_needed'.tr(),
            state.frequency == 'as_needed',
            onTap: () => notifier.updateFrequency('as_needed'),
          ),
          SizedBox(height: 32.h),
          Button(
            text: 'medicine.reminder.save'.tr(),
            onPressed: () => context.pop(),
            height: 48.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'medicine.reminder.frequency'.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            LucideIcons.x,
            color: const Color(0xFF64748B),
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context,
    String value,
    String label,
    bool isSelected, {
    required VoidCallback onTap,
    Widget? extra,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    LucideIcons.checkCircle2,
                    color: const Color(0xFF22C55E),
                    size: 20.sp,
                  ),
              ],
            ),
            if (extra != null) extra,
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelection(
    MedicineReminderState state,
    MedicineReminderNotifier notifier,
  ) {
    final days = [
      {'val': 1, 'label': 'medicine.reminder.mon'.tr()},
      {'val': 2, 'label': 'medicine.reminder.tue'.tr()},
      {'val': 3, 'label': 'medicine.reminder.wed'.tr()},
      {'val': 4, 'label': 'medicine.reminder.thu'.tr()},
      {'val': 5, 'label': 'medicine.reminder.fri'.tr()},
      {'val': 6, 'label': 'medicine.reminder.sat'.tr()},
      {'val': 7, 'label': 'medicine.reminder.sun'.tr()},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final isSelected = state.selectedDays.contains(day['val']);
          return GestureDetector(
            onTap: () => notifier.toggleDay(day['val'] as int),
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppColors.activeGradient : null,
                color: isSelected ? null : const Color(0xFFF1F5F9),
              ),
              child: Center(
                child: Text(
                  day['label'].toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9));
  }
}
