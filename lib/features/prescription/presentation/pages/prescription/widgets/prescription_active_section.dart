import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prescription.dart';
import 'prescription_active_card.dart';

class PrescriptionActiveSection extends StatelessWidget {
  const PrescriptionActiveSection({
    super.key,
    required this.prescriptions,
    required this.onPrescriptionTap,
  });

  final List<Prescription> prescriptions;
  final ValueChanged<Prescription> onPrescriptionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'prescription.active_title'.tr()} (${prescriptions.length})',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.typoBlack,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'prescription.active_subtitle'.tr(
              args: [prescriptions.length.toString()],
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.typoBody.withValues(alpha: 0.78),
            ),
          ),
          SizedBox(height: 16.h),
          ...prescriptions.map(
            (prescription) => PrescriptionActiveCard(
              prescription: prescription,
              onTap: () => onPrescriptionTap(prescription),
            ),
          ),
          SizedBox(height: 10.h),
          const _ActiveSectionBanner(),
        ],
      ),
    );
  }
}

class _ActiveSectionBanner extends StatelessWidget {
  const _ActiveSectionBanner();

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4F46E5);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFFE),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 18.sp, color: accent),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'prescription.info_banner'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBlack,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
