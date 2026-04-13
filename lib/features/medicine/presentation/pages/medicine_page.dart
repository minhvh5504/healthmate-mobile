import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/medicine/medicine_provider.dart';
import '../widgets/medicine/medicine_calendar_strip.dart';
import '../widgets/medicine/medicine_empty_state.dart';
import '../widgets/medicine/medicine_header.dart';
import '../widgets/medicine/medicine_skeleton.dart';
import '../widgets/medicine/medicine_cabinet_content.dart';
import '../../../../core/providers/user_provider.dart';

class MedicinePage extends ConsumerWidget {
  const MedicinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              /// Tab bar
              MedicineTabBar(
                selectedTab: state.selectedTab,
                onTabSelected: notifier.selectTab,
                avatarUrl: profile?.avatarUrl,
              ),

              SizedBox(height: 8.h),

              if (state.isLoading)
                const MedicineSkeleton()
              else ...[
                MedicineCalendarStrip(
                  selectedDate: state.selectedDate,
                  onDateSelected: notifier.selectDate,
                ),

                SizedBox(height: 8.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Center(
                    child: Text(
                      _formatDateLabel(state.selectedDate, context),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bgError,
                      ),
                    ),
                  ),
                ),

                ///Tab content
                Expanded(child: _buildTabContent(state, notifier)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the content area depending on the selected tab.
  Widget _buildTabContent(MedicineState state, MedicineNotifier notifier) {
    switch (state.selectedTab) {
      case MedicineTab.schedule:
        return MedicineEmptyState(onAddMedicine: notifier.onAddMedicine);
      case MedicineTab.cabinet:
        return const MedicineCabinetContent();
    }
  }

  /// Returns a human-readable label
  String _formatDateLabel(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final locale = EasyLocalization.of(context)?.currentLocale?.languageCode;
    final formatted = DateFormat('d MMM', locale).format(date);
    if (isToday) {
      return '${'medicine.today'.tr()}, $formatted';
    }
    return formatted;
  }
}
