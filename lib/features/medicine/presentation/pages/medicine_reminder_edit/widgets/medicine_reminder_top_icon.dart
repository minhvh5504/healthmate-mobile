import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineReminderTopIcon extends StatelessWidget {
  const MedicineReminderTopIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF434B94).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF434B94).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          AppIcons.medicineClock,
          width: 24.sp,
          height: 24.sp,
        ),
      ),
    );
  }
}
