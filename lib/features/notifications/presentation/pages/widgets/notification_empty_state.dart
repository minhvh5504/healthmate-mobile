import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_colors.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64.w, color: AppColors.typoDisable),
          SizedBox(height: 16.h),
          Text(
            'notifications.empty_state'.tr(),
            style: TextStyle(fontSize: 16.sp, color: AppColors.typoDisable),
          ),
        ],
      ),
    );
  }
}
