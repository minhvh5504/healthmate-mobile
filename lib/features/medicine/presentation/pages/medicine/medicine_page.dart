import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine/medicine_provider.dart';
import 'widgets/medicine_calendar_strip.dart';
import 'widgets/medicine_date_label.dart';
import 'widgets/medicine_header.dart';
import 'widgets/medicine_skeleton.dart';
import 'widgets/medicine_tab_content.dart';
import '../../../../../core/providers/user_provider.dart';

class MedicinePage extends ConsumerWidget {
  const MedicinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    final isInitialLoading = state.isLoading && state.isInitialLoad;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: isInitialLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    const Expanded(child: MedicineSkeleton()),
                  ],
                )
              : Column(
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

                    if (state.selectedTab == MedicineTab.schedule) ...[
                      MedicineCalendarStrip(
                        selectedDate: state.selectedDate,
                        onDateSelected: notifier.selectDate,
                      ),
                      SizedBox(height: 8.h),
                      const MedicineDateLabel(),
                    ],

                    /// Tab content
                    const Expanded(child: MedicineTabContent()),
                  ],
                ),
        ),
      ),
    );
  }
}
