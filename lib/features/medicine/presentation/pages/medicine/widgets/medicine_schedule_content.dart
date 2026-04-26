import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine/medicine_provider.dart';
import 'medicine_empty_state.dart';
import 'medicine_schedule_card.dart';

class MedicineScheduleContent extends ConsumerWidget {
  const MedicineScheduleContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);

    final schedule = state.dailySchedule;

    if (schedule == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.typoPrimary),
      );
    }

    final hasData =
        schedule.morning.isNotEmpty ||
        schedule.afternoon.isNotEmpty ||
        schedule.evening.isNotEmpty;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        if (!hasData)
          MedicineEmptyState(onAddMedicine: notifier.onAddMedicine)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (schedule.morning.isNotEmpty) ...[
                _buildSectionHeader('SÁNG', LucideIcons.sun),
                SizedBox(height: 12.h),
                ...schedule.morning.map(
                  (item) => MedicineScheduleCard(item: item),
                ),
                SizedBox(height: 16.h),
              ],

              if (schedule.afternoon.isNotEmpty) ...[
                _buildSectionHeader('CHIỀU', LucideIcons.sunset),
                SizedBox(height: 12.h),
                ...schedule.afternoon.map(
                  (item) => MedicineScheduleCard(item: item),
                ),
                SizedBox(height: 16.h),
              ],

              if (schedule.evening.isNotEmpty) ...[
                _buildSectionHeader('TỐI', LucideIcons.moon),
                SizedBox(height: 12.h),
                ...schedule.evening.map(
                  (item) => MedicineScheduleCard(item: item),
                ),
                SizedBox(height: 16.h),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.orange),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBody,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
