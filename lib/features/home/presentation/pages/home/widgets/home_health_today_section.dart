import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/home_provider.dart';
import 'health_status_section.dart';

class HomeHealthTodaySection extends ConsumerWidget {
  const HomeHealthTodaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final homeState = ref.watch(homeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'home.medicine_today'.tr(),
                style: TextStyle(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                ),
              ),
            ),
            InkWell(
              onTap: homeNotifier.onMedicine,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'home.view_all'.tr(),
                      style: TextStyle(
                        color: const Color(0xFF5D63F1),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.sp,
                      color: const Color(0xFF5D63F1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        HealthStatusSection(
          schedule: homeState.dailySchedule,
          isLoading: homeState.isLoading,
          onTap: homeNotifier.onMedicine,
        ),
      ],
    );
  }
}
