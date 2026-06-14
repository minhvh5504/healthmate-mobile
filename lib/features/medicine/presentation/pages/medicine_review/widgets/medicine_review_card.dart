import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineReviewCard extends StatelessWidget {
  final Map<String, dynamic> medication;
  final bool isCentered;

  const MedicineReviewCard({
    super.key,
    required this.medication,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    final String name = medication['name'] ?? 'medicine.scan.unknown_name'.tr();
    final String dosage = medication['dosage'] ?? '';
    final String fullName = dosage.isNotEmpty ? '$name $dosage' : name;

    final String frequencySlug = medication['frequency'] ?? 'daily';
    final String frequency = frequencySlug == 'as_needed'
        ? 'medicine.reminder.as_needed'.tr()
        : 'medicine.reminder.daily'.tr();

    final bool isAsNeeded = frequencySlug == 'as_needed';
    final List<dynamic> schedules = medication['schedules'] ?? [];
    final quantity = schedules.isNotEmpty
        ? int.tryParse(schedules[0]['quantity']?.toString() ?? '1') ?? 1
        : 1;
    final unit = medication['unit'] ?? 'medicine.unit_default'.tr();
    final String timeInfo = !isAsNeeded && schedules.isNotEmpty
        ? '${schedules[0]['time']} • $quantity $unit'
        : '';

    final int stockCount = medication['stockCount'] ?? 0;
    final String stockInfo = 'medicine.stock_remaining'.tr(
      args: [stockCount.toString()],
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppIcons.medicineLight,
              width: 30.w,
              height: 30.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.typoBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  frequency,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.typoDisable,
                  ),
                ),
                if (medication['genericName'] != null &&
                    medication['genericName'] != '-') ...[
                  SizedBox(height: 2.h),
                  Text(
                    medication['genericName'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoDisable,
                    ),
                  ),
                ],
                if (timeInfo.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    timeInfo,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoDisable,
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                Text(
                  stockInfo,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.typoDisable,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
