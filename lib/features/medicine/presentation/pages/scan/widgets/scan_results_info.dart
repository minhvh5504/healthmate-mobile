import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/scan_task.dart';
import '../../../providers/medicine/medicine_provider.dart';

class ScanResultsInfo extends ConsumerWidget {
  final String taskId;

  const ScanResultsInfo({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final scanTask = medicineState.scanTasks.cast<ScanTask?>().firstWhere(
      (task) => task?.id == taskId,
      orElse: () => null,
    );
    final isFailed = scanTask?.status == ScanStatus.failed;
    final medications = medicineState.reviewMedications;
    final hasMatchedMedications = medications.any(
      (med) => med['isMatched'] == true,
    );
    final imagePath =
        scanTask?.imagePath ?? medicineState.reviewImagePath ?? '';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: imagePath.isNotEmpty
              ? _buildScanImage(imagePath)
              : _buildFallbackImage(),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: _buildMessage(isFailed, hasMatchedMedications),
        ),
      ],
    );
  }

  Widget _buildMessage(bool isFailed, bool hasMatchedMedications) {
    if (isFailed) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'medicine.scan.unrecognized_message_prefix'.tr()),
            TextSpan(
              text: 'medicine.scan.retry'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: 'medicine.scan.unrecognized_message_suffix'.tr()),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.typoBody,
          height: 1.45,
        ),
      );
    }

    return Text(
      hasMatchedMedications
          ? 'medicine.scan.results_found'.tr()
          : 'medicine.scan.no_results_found'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.typoBlack,
      ),
    );
  }

  Widget _buildScanImage(String imagePath) {
    final isRemote =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isRemote) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        cacheKey: imagePath,
        width: 200.w,
        height: 200.w,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildImageShimmer(),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    }

    return Image.file(
      File(imagePath),
      width: 200.w,
      height: 200.w,
      fit: BoxFit.cover,
      cacheWidth: 256,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _buildImageShimmer();
      },
      errorBuilder: (_, __, ___) => _buildFallbackImage(),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: 200.w,
        height: 200.w,
        color: Colors.white,
      ),
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
