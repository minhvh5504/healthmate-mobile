import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';

class AppVersionFooter extends StatelessWidget {
  const AppVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'settings.app_version'.tr(),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            color: AppColors.typoDisable,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          '© 2026 HealthMate',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            color: AppColors.typoDisable,
          ),
        ),
      ],
    );
  }
}
