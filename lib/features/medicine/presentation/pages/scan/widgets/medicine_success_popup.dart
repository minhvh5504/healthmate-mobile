import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/lottie_animation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineSuccessPopup extends StatelessWidget {
  final VoidCallback onAddNew;
  final VoidCallback onViewCabinet;
  final VoidCallback onComplete;

  const MedicineSuccessPopup({
    super.key,
    required this.onAddNew,
    required this.onViewCabinet,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
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
            Text(
              'medicine.scan.success_title'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.typoBlack,
              ),
            ),
            SizedBox(height: 8.h),

            LottieAnimation.success(size: 200.w),
            SizedBox(height: 8.h),

            Text(
              'medicine.scan.success_message'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBody,
              ),
            ),
            SizedBox(height: 16.h),

            // Buttons
            Button(
              text: 'medicine.scan.add_new'.tr(),
              onPressed: onAddNew,
              color: Colors.white,
              textColor: AppColors.typoBlack,
              height: 48.h,
              width: double.infinity,
            ),
            SizedBox(height: 12.h),
            Button(
              text: 'medicine.scan.view_cabinet'.tr(),
              onPressed: onViewCabinet,
              color: Colors.white,
              textColor: AppColors.typoBlack,
              height: 48.h,
              width: double.infinity,
            ),
            SizedBox(height: 12.h),
            Button(
              text: 'medicine.scan.complete'.tr(),
              onPressed: onComplete,
              height: 52.h,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
