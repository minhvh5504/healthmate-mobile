import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/prescription.dart';
import 'prescription_details_action_buttons.dart';
import 'prescription_details_info_row.dart';

class PrescriptionDetailsCard extends StatelessWidget {
  const PrescriptionDetailsCard({
    super.key,
    required this.prescription,
    required this.onViewImage,
    required this.onUpdate,
    required this.onDeactivate,
    required this.onDelete,
    required this.onActivate,
  });

  final Prescription prescription;
  final VoidCallback onViewImage;
  final VoidCallback onUpdate;
  final VoidCallback onDeactivate;
  final VoidCallback onDelete;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final endDate = prescription.endDate;
    final note = prescription.note?.trim();

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 18.h),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'prescription.details.card_title'.tr(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.typoBlack,
                  ),
                ),
              ),
              if (prescription.isActive) const _ActiveBadge(),
            ],
          ),
          SizedBox(height: 18.h),
          _PrescriptionImage(
            imageUrl: prescription.imageUrl,
            onViewImage: onViewImage,
          ),
          SizedBox(height: 22.h),
          PrescriptionDetailsInfoRow(
            icon: LucideIcons.user,
            label: 'prescription.details.doctor'.tr(),
            value: prescription.doctorName,
          ),
          PrescriptionDetailsInfoRow(
            icon: LucideIcons.building2,
            label: 'prescription.details.clinic'.tr(),
            value: prescription.clinicName,
          ),
          PrescriptionDetailsInfoRow(
            iconAsset: AppIcons.calendarRange,
            label: 'prescription.details.start_date'.tr(),
            value: dateFormat.format(prescription.startDate),
          ),
          PrescriptionDetailsInfoRow(
            iconAsset: AppIcons.calendarRange,
            label: 'prescription.details.end_date'.tr(),
            value: endDate != null
                ? '${dateFormat.format(endDate)} ${'prescription.estimated'.tr()}'
                : '-',
            valueColor: AppColors.typoWarning,
          ),
          PrescriptionDetailsInfoRow(
            icon: LucideIcons.fileText,
            label: 'prescription.details.note'.tr(),
            value: note?.isNotEmpty == true
                ? note!
                : 'prescription.details.no_note'.tr(),
          ),
          SizedBox(height: 16.h),
          PrescriptionDetailsActionButtons(
            isActive: prescription.isActive,
            onDeactivate: onDeactivate,
            onUpdate: onUpdate,
            onDelete: onDelete,
            onActivate: onActivate,
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F8EE),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        'prescription.status_active'.tr(),
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

class _PrescriptionImage extends StatelessWidget {
  const _PrescriptionImage({this.imageUrl, this.onViewImage});

  final String? imageUrl;
  final VoidCallback? onViewImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: hasImage ? onViewImage : null,
      child: Container(
        width: double.infinity,
        height: 188.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            hasImage
                ? Image.network(imageUrl!, fit: BoxFit.cover)
                : Icon(
                    LucideIcons.fileText,
                    size: 52.sp,
                    color: AppColors.typoDisable,
                  ),
            if (hasImage && onViewImage != null)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: onViewImage,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.eye,
                      size: 18.sp,
                      color: AppColors.typoBlack,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
