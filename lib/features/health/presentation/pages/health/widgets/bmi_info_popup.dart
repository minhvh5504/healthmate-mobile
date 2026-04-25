import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BMIInfoPopup extends StatefulWidget {
  const BMIInfoPopup({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'BMI Info Popup',
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
              const Center(child: BMIInfoPopup()),
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
  State<BMIInfoPopup> createState() => _BMIInfoPopupState();
}

class _BMIInfoPopupState extends State<BMIInfoPopup> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.w),
        child: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Close Button
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'health.bmi_info.title'.tr(),
                              style: TextStyle(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.typoBlack,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'health.bmi_info.how_it_calculated'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.typoBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Description
                      Text(
                        'health.bmi_info.description'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.typoBody.withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Categories
                      _buildCategoryItem(
                        color: const Color(0xFF3ABEF9),
                        title: 'health.bmi_info.underweight_title'.tr(),
                        description: 'health.bmi_info.underweight_desc'.tr(),
                      ),
                      SizedBox(height: 24.h),
                      _buildCategoryItem(
                        color: const Color(0xFF50E38B),
                        title: 'health.bmi_info.normal_title'.tr(),
                        description: 'health.bmi_info.normal_desc'.tr(),
                      ),

                      // Expandable Section
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _isExpanded
                              ? Column(
                                  children: [
                                    _buildCategoryItem(
                                      color: const Color(0xFFFFD620),
                                      title: 'health.bmi_info.overweight_title'
                                          .tr(),
                                      description:
                                          'health.bmi_info.overweight_desc'
                                              .tr(),
                                    ),
                                    SizedBox(height: 24.h),
                                    _buildCategoryItem(
                                      color: const Color(0xFFFF7E8E),
                                      title: 'health.bmi_info.obese_title'.tr(),
                                      description: 'health.bmi_info.obese_desc'
                                          .tr(),
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Expand/Collapse Toggle
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 300),
                            turns: _isExpanded ? 0.5 : 0,
                            child: Icon(
                              LucideIcons.chevronDown,
                              color: const Color(0xFF7F66FF),
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Note Section
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.typoBlack,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'health.bmi_info.note_title'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: 'health.bmi_info.note_content'.tr(),
                              style: TextStyle(
                                color: AppColors.typoBody.withValues(
                                  alpha: 0.8,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.h),
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.typoBlack,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.typoBody.withValues(alpha: 0.7),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
