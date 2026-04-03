import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class ProfileErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileErrorBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bgError.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.bgError.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 18.sp,
            color: AppColors.typoError,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                color: AppColors.typoError,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Thử lại',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
