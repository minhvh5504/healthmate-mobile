import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/history/history_provider.dart';
import 'widgets/history_adherence_card.dart';
import 'widgets/history_calendar_card.dart';
import 'widgets/history_log_list.dart';
import 'widgets/history_skeleton.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFF2F4FD)),
        child: SafeArea(
          child: state.isLoading && state.isInitialLoad
              ? const HistorySkeleton()
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        'history.title'.tr(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.typoBlack,
                        ),
                      ).animate().fadeIn(duration: 220.ms),
                      SizedBox(height: 24.h),
                      // Adherence Card
                      HistoryAdherenceCard(
                        percentage: state.monthlyAdherence,
                        focusedMonth: state.focusedMonth,
                      ).animate().fadeIn(duration: 220.ms, delay: 60.ms),
                      SizedBox(height: 24.h),
                      // Calendar Card
                      const HistoryCalendarCard().animate().fadeIn(
                        duration: 220.ms,
                        delay: 120.ms,
                      ),
                      SizedBox(height: 16.h),
                      // Log List
                      const HistoryLogList().animate().fadeIn(
                        duration: 220.ms,
                        delay: 180.ms,
                      ),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
