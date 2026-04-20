import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineOptionsLabel extends StatelessWidget {
  const MedicineOptionsLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'medicine.only_if_needed'.tr(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: AppColors.typoBody.withValues(alpha: 0.8),
      ),
    );
  }
}
