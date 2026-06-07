import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/constant_url.dart';

import '../../../../../../core/theme/app_colors.dart';

class ReviewMedicationCard extends StatelessWidget {
  final Map<String, dynamic> medication;

  const ReviewMedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final String name = medication['name'] ?? 'medicine.scan.unknown_name'.tr();
    final String genericName =
        medication['genericName'] ?? 'medicine.scan.basic_medicine'.tr();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppIcons.medicineMoreLight,
              width: 48.w,
              height: 48.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  genericName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.typoBody.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
