import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prescription.dart';

class PrescriptionHistoryItem extends StatelessWidget {
  const PrescriptionHistoryItem({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  final Prescription prescription;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startStr = dateFormat.format(prescription.startDate);
    final endStr = prescription.endDate != null
        ? dateFormat.format(prescription.endDate!)
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _HistoryThumbnail(imageUrl: prescription.imageUrl),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'prescription.history_item_title'.tr()} $startStr',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    prescription.doctorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoBody.withValues(alpha: 0.82),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.calendarRange,
                        width: 12.sp,
                        height: 12.sp,
                        colorFilter: ColorFilter.mode(
                          AppColors.typoBody.withValues(alpha: 0.72),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          endStr.isNotEmpty ? '$startStr - $endStr' : startStr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.typoBody.withValues(alpha: 0.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              LucideIcons.chevronRight,
              size: 18.sp,
              color: AppColors.typoBody.withValues(alpha: 0.62),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryThumbnail extends StatelessWidget {
  const _HistoryThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66.w,
      height: 58.h,
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
              size: 20.sp,
              color: AppColors.typoDisable,
            )
          : null,
    );
  }
}
