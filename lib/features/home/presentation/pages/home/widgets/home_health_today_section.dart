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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.health_today'.tr(),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.typoBlack,
          ),
        ),
        SizedBox(height: 8.h),
        HealthStatusSection(onTap: homeNotifier.onUpdateHealth),
      ],
    );
  }
}
