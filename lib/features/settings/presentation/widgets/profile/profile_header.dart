import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ProfileHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 24.w, top: 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'settings.basic_info'.tr(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoBlack,
            ),
          ),
        ],
      ),
    );
  }
}
