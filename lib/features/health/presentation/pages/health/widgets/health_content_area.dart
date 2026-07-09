import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import 'package:healthmate_mobile/core/routing/app_routes.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/bmi_popup.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_metric_card.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/bmi_card.dart';

// Popup nhập chỉ số tạm comment lại theo yêu cầu.
// import 'package:animations/animations.dart';
// import 'package:healthmate_mobile/core/theme/app_colors.dart';
// import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/height_metric_popup.dart';
// import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/weight_metric_popup.dart';

class HealthContentArea extends ConsumerWidget {
  const HealthContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthState = ref.watch(healthProvider);
    final profile = healthState.userProfile;

    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile != null) ...[
              HealthMetricCard(
                title: 'health.weight'.tr(),
                iconPath: AppIcons.healthWeight,
                currentValue: profile.weightKg != null
                    ? profile.weightKg!.toStringAsFixed(1)
                    : '--',
                unit: 'kg',
                difference: healthState.weightDifference,
                onTap: () => context.push(
                  AppRoutes.healthHistory,
                  extra: HealthHistoryMetric.weight,
                ),
                // Popup nhập cân nặng cũ:
                // onTap: () => _showMetricPopup(
                //   context,
                //   WeightMetricPopup(initialValue: profile.weightKg ?? 0.0),
                // ),
              ).animate().fadeIn(duration: 220.ms, delay: 0.ms),
              SizedBox(height: 8.h),
              HealthMetricCard(
                title: 'health.height'.tr(),
                iconPath: AppIcons.healthHeight,
                currentValue: profile.heightCm != null
                    ? profile.heightCm!.toStringAsFixed(1)
                    : '--',
                unit: 'cm',
                difference: healthState.heightDifference,
                onTap: () => context.push(
                  AppRoutes.healthHistory,
                  extra: HealthHistoryMetric.height,
                ),
                // Popup nhập chiều cao cũ:
                // onTap: () => _showMetricPopup(
                //   context,
                //   HeightMetricPopup(initialValue: profile.heightCm ?? 0.0),
                // ),
              ).animate().fadeIn(duration: 220.ms, delay: 60.ms),
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
              ).animate().fadeIn(duration: 220.ms, delay: 120.ms),
            ],
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  // Popup nhập chỉ số cũ, giữ lại để bật lại khi cần.
  // void _showMetricPopup(BuildContext context, Widget popup) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Health Metric Popup',
  //     barrierColor: Colors.black.withValues(alpha: 0.2),
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (context, anim1, anim2) {
  //       return Scaffold(
  //         backgroundColor: Colors.transparent,
  //         body: Stack(
  //           children: [
  //             GestureDetector(
  //               onTap: () => context.pop(),
  //               child: Container(
  //                 width: double.infinity,
  //                 height: double.infinity,
  //                 decoration: const BoxDecoration(
  //                   gradient: AppColors.backgroundGradient,
  //                 ),
  //               ),
  //             ),
  //             Center(child: popup),
  //           ],
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return FadeScaleTransition(animation: anim1, child: child);
  //     },
  //   );
  // }
}
