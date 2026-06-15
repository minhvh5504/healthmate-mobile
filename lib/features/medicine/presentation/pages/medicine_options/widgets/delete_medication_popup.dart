import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class DeleteMedicationPopup extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteMedicationPopup({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'medicine.delete_dialog.delete_one_title'.tr(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.typoBlack,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'medicine.delete_dialog.delete_one_message'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            Button(
              text: 'medicine.delete_dialog.confirm'.tr(),
              color: AppColors.typoError,
              onPressed: () {
                onConfirm();
                context.pop();
              },
              height: 52.h,
              width: double.infinity,
            ),
            SizedBox(height: 12.h),
            Button(
              text: 'medicine.delete_dialog.cancel'.tr(),
              color: Colors.white,
              textColor: AppColors.typoBlack,
              borderColor: const Color(0xFFF1F5F9),
              onPressed: () => context.pop(),
              height: 52.h,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
