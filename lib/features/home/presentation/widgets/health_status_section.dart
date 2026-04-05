import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class HealthStatusSection extends StatelessWidget {
  final VoidCallback? onTap;

  const HealthStatusSection({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustration
            Image.asset(
              'assets/icons/home/not_found.png',
              width: 200.sp,
              height: 200.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),

            // Status text
            Text(
              'home.no_changes_today'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4338CA),
              ),
            ),
            SizedBox(height: 2.h),

            // Action hint
            Text(
              'home.update_to_track'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.typoBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
