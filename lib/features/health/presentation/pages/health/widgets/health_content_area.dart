import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/bmi_popup.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_metric_card.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/bmi_card.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/weight_metric_popup.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/height_metric_popup.dart';

class HealthContentArea extends ConsumerWidget {
  const HealthContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthState = ref.watch(healthProvider);
    final profile = healthState.userProfile;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(16, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'health.title'.tr(),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.typoBlack,
                ),
              ),
              SizedBox(height: 2.h),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'health.overview'.tr(),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.typoBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4D),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              if (profile != null) ...[
                HealthMetricCard(
                  title: 'health.weight'.tr(),
                  iconPath: 'assets/icons/health/scale.png',
                  currentValue: profile.weightKg != null
                      ? profile.weightKg!.toStringAsFixed(1)
                      : '--',
                  unit: 'kg',
                  difference: healthState.weightDifference,
                  onTap: () => _showMetricPopup(
                    context,
                    WeightMetricPopup(initialValue: profile.weightKg ?? 0.0),
                  ),
                ),
                SizedBox(height: 8.h),
                HealthMetricCard(
                  title: 'health.height'.tr(),
                  iconPath: 'assets/icons/health/flame.png',
                  currentValue: profile.heightCm != null
                      ? profile.heightCm!.toStringAsFixed(1)
                      : '--',
                  unit: 'cm',
                  difference: healthState.heightDifference,
                  onTap: () => _showMetricPopup(
                    context,
                    HeightMetricPopup(initialValue: profile.heightCm ?? 0.0),
                  ),
                ),
                SizedBox(height: 8.h),
                BMICard(
                  bmi: profile.bmi ?? 0,
                  status: HealthNotifier.formatBMIStatus(profile.bmiStatus),
                  statusColor: HealthNotifier.getBMIColor(profile.bmiStatus),
                  onTap: () => BMIPopup.show(
                    context,
                    bmi: profile.bmi ?? 0,
                    status: HealthNotifier.formatBMIStatus(profile.bmiStatus),
                    statusColor: HealthNotifier.getBMIColor(profile.bmiStatus),
                  ),
                ),
              ],
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showMetricPopup(BuildContext context, Widget popup) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Health Metric Popup',
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
              Center(child: popup),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }
}
