import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bmi_info_popup.dart';

class BMIPopup extends ConsumerWidget {
  final double bmi;
  final String status;
  final Color statusColor;

  const BMIPopup({
    super.key,
    required this.bmi,
    required this.status,
    required this.statusColor,
  });

  static void show(
    BuildContext context, {
    required double bmi,
    required String status,
    required Color statusColor,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'BMI Analysis Popup',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: BMIPopup(
                  bmi: bmi,
                  status: status,
                  statusColor: statusColor,
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthState = ref.watch(healthProvider);
    final analysis = healthState.healthAnalysis;
    final isAnalysisLoading = healthState.isAnalysisLoading;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.w),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'health.bmi_analysis_title'.tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.typoBlack,
                          height: 1.1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A1C1E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Highlight Badge & Subtitle
                _buildBadge(
                  'health.highlight'.tr(),
                  const Color(0xFFE5E7EB),
                  const Color(0xFF6B7280),
                ),
                SizedBox(height: 6.h),
                Text(
                  'health.bmi_analysis_subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.typoBody.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),

                // BMI Summary Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${'health.bmi_label'.tr()} • ${bmi.toStringAsFixed(1)} • $status',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.typoBlack,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildBMIProgressBar(),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => BMIInfoPopup.show(context),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.helpCircle,
                              size: 16.sp,
                              color: AppColors.typoHeading.withValues(
                                alpha: 0.9,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'health.bmi_definition_link'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.typoHeading.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Assessment Section
                if (isAnalysisLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  _buildBadge(
                    'health.assessment'.tr(),
                    const Color(0xFFE5E7EB),
                    const Color(0xFF6B7280),
                  ),
                  SizedBox(height: 8.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.typoBody.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(text: 'health.bmi_assessment_prefix'.tr()),
                        if (analysis?.percentage != null &&
                            analysis!.percentage! > 0)
                          TextSpan(
                            text: ' ${analysis.percentage}% ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF434B94),
                            ),
                          ),
                        TextSpan(
                          text: HealthNotifier.getAssessmentStatusText(
                            analysis?.status,
                          ).tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF434B94),
                          ),
                        ),
                        TextSpan(text: 'health.bmi_assessment_suffix'.tr()),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Comparison Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'health.you'.tr().toUpperCase(),
                          bmi.toStringAsFixed(1),
                          const Color(0xFFF5F3FF),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildStatCard(
                          HealthNotifier.formatPeerDescription(
                            analysis?.peerDescription,
                          ).toUpperCase(),
                          analysis?.peerBMI?.toStringAsFixed(1) ?? '--',
                          const Color(0xFFF5F3FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Peer Analysis Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C728E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.user,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'health.compare_with_peers'.tr().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              Text(
                                'health.peer_analysis'.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.typoBlack,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        HealthNotifier.getAnalysisStatusColor(
                                          analysis?.status,
                                        ),
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      HealthNotifier.getPeerStatusText(
                                        analysis?.status,
                                      ).tr(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            HealthNotifier.getAnalysisStatusColor(
                                              analysis?.status,
                                            ),
                                      ),
                                    ),
                                    if (HealthNotifier.getAnalysisStatusIcon(
                                          analysis?.status,
                                        ) !=
                                        null) ...[
                                      SizedBox(width: 4.w),
                                      Icon(
                                        HealthNotifier.getAnalysisStatusIcon(
                                          analysis?.status,
                                        ),
                                        size: 12.sp,
                                        color:
                                            HealthNotifier.getAnalysisStatusColor(
                                              analysis?.status,
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBMIProgressBar() {
    return Row(
      children: [
        _buildProgressSegment(const Color(0xFF3ABEF9)), // Underweight
        SizedBox(width: 4.w),
        _buildProgressSegment(const Color(0xFF50E38B)), // Normal
        SizedBox(width: 4.w),
        _buildProgressSegment(const Color(0xFFFFD620)), // Overweight
        SizedBox(width: 4.w),
        _buildProgressSegment(const Color(0xFFFF7E8E)), // Obese
      ],
    );
  }

  Widget _buildProgressSegment(Color color) {
    return Expanded(
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.typoBlack,
            ),
          ),
        ],
      ),
    );
  }
}
