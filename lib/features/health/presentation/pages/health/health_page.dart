import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/core/widgets/header/app_header.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_content_area.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_skeleton.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';

class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthState = ref.watch(healthProvider);

    if (healthState.isLoading && healthState.userProfile == null) {
      return const HealthSkeleton();
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
                child: Text(
                  'health.title'.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoBlack,
                  ),
                ).animate().fadeIn(duration: 220.ms),
              ),
              const HealthContentArea(),
            ],
          ),
        ),
      ),
    );
  }
}
