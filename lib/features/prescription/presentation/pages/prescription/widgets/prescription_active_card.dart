import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prescription.dart';

class PrescriptionActiveCard extends StatelessWidget {
  const PrescriptionActiveCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  final Prescription prescription;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final endDate = prescription.endDate;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 12.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFDCD8FF), width: 1.2),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PrescriptionThumbnail(imageUrl: prescription.imageUrl),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 80.w),
                        child: Text(
                          prescription.doctorName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.typoBlack,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        prescription.clinicName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.typoBody.withValues(alpha: 0.82),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        dateFormat.format(prescription.startDate),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.typoBody.withValues(alpha: 0.82),
                        ),
                      ),
                      if (endDate != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          '${dateFormat.format(endDate)} ${'prescription.estimated'.tr()}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.typoWarning,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  LucideIcons.chevronRight,
                  size: 22.sp,
                  color: AppColors.typoBody.withValues(alpha: 0.62),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _StatusBadge(label: 'prescription.status_active'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F8EE),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.bgSuccess,
          height: 1,
        ),
      ),
    );
  }
}

class _PrescriptionThumbnail extends StatelessWidget {
  const _PrescriptionThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.w,
      height: 84.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(8.r),
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Icon(
              LucideIcons.fileText,
              size: 24.sp,
              color: AppColors.typoDisable,
            )
          : null,
    );
  }
}
