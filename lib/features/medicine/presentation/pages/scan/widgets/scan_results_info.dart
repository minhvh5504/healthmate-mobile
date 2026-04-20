import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine/medicine_provider.dart';

class ScanResultsInfo extends ConsumerWidget {
  const ScanResultsInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final medications = medicineState.reviewMedications;
    final imagePath = medicineState.reviewImagePath ?? '';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: imagePath.isNotEmpty
              ? Image.file(
                  File(imagePath),
                  width: 200.w,
                  height: 200.w,
                  fit: BoxFit.cover,
                  cacheWidth: 256,
                  errorBuilder: (_, __, ___) => _buildFallbackImage(),
                )
              : _buildFallbackImage(),
        ),
        SizedBox(height: 24.h),
        Text(
          medications.isNotEmpty
              ? 'medicine.scan.results_found'.tr(
                  args: [medications.length.toString()],
                )
              : 'medicine.scan.no_results_found'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.typoHeading.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 200.w,
      height: 200.w,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Icon(LucideIcons.image, size: 48.sp, color: Colors.grey),
    );
  }
}
