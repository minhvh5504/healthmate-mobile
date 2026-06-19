import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/theme/app_colors.dart';

class PrescriptionDetailsHeader extends StatelessWidget {
  const PrescriptionDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 10.h),
      child: SizedBox(
        height: 44.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  alignment: Alignment.center,
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
            Text(
              'prescription.details.title'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.typoBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
