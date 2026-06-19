import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prescription.dart';
import 'prescription_history_item.dart';

class PrescriptionHistorySection extends StatelessWidget {
  const PrescriptionHistorySection({
    super.key,
    required this.prescriptions,
    required this.onViewAll,
    required this.onPrescriptionTap,
  });

  final List<Prescription> prescriptions;
  final VoidCallback onViewAll;
  final ValueChanged<Prescription> onPrescriptionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'prescription.history_title'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'prescription.view_all'.tr(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...prescriptions
              .take(3)
              .map(
                (prescription) => PrescriptionHistoryItem(
                  prescription: prescription,
                  onTap: () => onPrescriptionTap(prescription),
                ),
              ),
        ],
      ),
    );
  }
}
