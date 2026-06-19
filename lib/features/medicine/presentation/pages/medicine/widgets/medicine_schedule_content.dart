import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine/medicine_provider.dart';
import 'medicine_empty_state.dart';
import 'medicine_schedule_card.dart';
import 'medicine_skeleton.dart';

class MedicineScheduleContent extends ConsumerWidget {
  const MedicineScheduleContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);

    final schedule = state.dailySchedule;
    final canLogMedication = !_isFutureDate(state.selectedDate);

    if (schedule == null) {
      return const MedicineScheduleListSkeleton();
    }

    final hasData =
        schedule.morning.isNotEmpty ||
        schedule.afternoon.isNotEmpty ||
        schedule.evening.isNotEmpty;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      children: [
        if (!hasData)
          const MedicineEmptyState()
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (schedule.morning.isNotEmpty) ...[
                _buildSectionHeader(
                  'medicine.period.morning'.tr(),
                  AppIcons.medicineSunny,
                ),
                SizedBox(height: 8.h),
                ...schedule.morning.map(
                  (item) => MedicineScheduleCard(
                    item: item,
                    canLogMedication: canLogMedication,
                  ),
                ),
                SizedBox(height: 8.h),
              ],

              if (schedule.afternoon.isNotEmpty) ...[
                _buildSectionHeader(
                  'medicine.period.afternoon'.tr(),
                  AppIcons.medicineSunny,
                ),
                SizedBox(height: 8.h),
                ...schedule.afternoon.map(
                  (item) => MedicineScheduleCard(
                    item: item,
                    canLogMedication: canLogMedication,
                  ),
                ),
                SizedBox(height: 8.h),
              ],

              if (schedule.evening.isNotEmpty) ...[
                _buildSectionHeader(
                  'medicine.period.evening'.tr(),
                  AppIcons.medicineNight,
                ),
                SizedBox(height: 8.h),
                ...schedule.evening.map(
                  (item) => MedicineScheduleCard(
                    item: item,
                    canLogMedication: canLogMedication,
                  ),
                ),
                SizedBox(height: 8.h),
              ],

              SizedBox(height: 8.h),
              Button(
                height: 48.h,
                text:
                    '${tr('high_settings.update')} ${tr('medicine.tab_cabinet').toLowerCase()}',
                icon: Icon(
                  LucideIcons.package,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () => notifier.selectTab(MedicineTab.cabinet),
              ),
              SizedBox(height: 100.h),
            ],
          ),
      ],
    );
  }

  bool _isFutureDate(DateTime date) {
    final today = DateTime.now();
    final selectedDay = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return selectedDay.isAfter(todayOnly);
  }

  Widget _buildSectionHeader(String title, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20.w, height: 20.w),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.typoBody,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
