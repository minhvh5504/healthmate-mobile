import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineOptionsIcon extends StatelessWidget {
  const MedicineOptionsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7A7EAC), AppColors.typoHeading],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppIcons.medicine,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 36.sp,
          height: 36.sp,
        ),
      ),
    );
  }
}
