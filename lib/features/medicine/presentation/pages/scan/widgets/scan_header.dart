import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theme/app_colors.dart';

class ScanHeader extends StatelessWidget implements PreferredSizeWidget {
  const ScanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 60.w,
      leading: Center(
        child: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(50.r),
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
      ),
      title: Text(
        'medicine.scan.review_title'.tr(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.typoHeading,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
