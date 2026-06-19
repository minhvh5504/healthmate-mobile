import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';

class PrescriptionDetailsActionButtons extends StatelessWidget {
  const PrescriptionDetailsActionButtons({
    super.key,
    required this.isActive,
    required this.onDeactivate,
    required this.onUpdate,
    required this.onDelete,
    required this.onActivate,
  });

  final bool isActive;
  final VoidCallback onDeactivate;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDeactivate,
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromHeight(44.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                side: BorderSide(
                  color: AppColors.typoDisable.withValues(alpha: 0.28),
                  width: 1.5.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'prescription.details.deactivate'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.typoBlack,
                foregroundColor: Colors.white,
                fixedSize: Size.fromHeight(44.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'prescription.details.update'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                fixedSize: Size.fromHeight(44.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                side: BorderSide(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                  width: 1.5.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'prescription.details.delete_btn'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onActivate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.typoBlack,
                foregroundColor: Colors.white,
                fixedSize: Size.fromHeight(44.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'prescription.details.activate'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
