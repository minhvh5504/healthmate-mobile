import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';

class ViewAllHealthHistoryEmptyState extends StatelessWidget {
  const ViewAllHealthHistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.notFound,
            width: 180.w,
            height: 180.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            'health.history_empty_state'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoBody,
            ),
          ),
        ],
      ),
    );
  }
}
