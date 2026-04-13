import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine/medicine_provider.dart';

class ReviewScanPage extends ConsumerStatefulWidget {
  final String taskId;

  const ReviewScanPage({super.key, required this.taskId});

  @override
  ConsumerState<ReviewScanPage> createState() => _ReviewScanPageState();
}

class _ReviewScanPageState extends ConsumerState<ReviewScanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineProvider.notifier).selectTaskForReview(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineProvider);
    final medications = state.reviewMedications;
    final imagePath = state.reviewImagePath ?? '';
    final notifier = ref.read(medicineProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: AppColors.typoHeading,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Xem lại thuốc của bạn',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoHeading,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.h),
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
                  ? '${medications.length} loại thuốc được tìm thấy! Vui lòng\nkiểm tra lại thông tin để tránh sai sót.'
                  : 'Không tìm thấy thuốc nào!\nBạn có thể thử lại hoặc thêm thủ công.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 24.h),
            if (medications.isNotEmpty)
              ...medications.map<Widget>((med) => _buildMedicationCard(med)),

            SizedBox(height: 32.h),
            _buildOutlinedButton(
              text: 'Xóa tất cả thuốc',
              textColor: Colors.red,
              onTap: () {
                notifier.deleteScanTask(widget.taskId);
                context.pop();
              },
            ),
            SizedBox(height: 16.h),
            if (medications.isNotEmpty)
              _buildFilledButton(
                text: 'Thêm vào hộp thuốc',
                onTap: () {
                  notifier.saveMedicinesToCabinet(widget.taskId);
                  context.pop();
                },
              )
            else
              _buildFilledButton(
                text: 'Thêm thủ công',
                onTap: () {
                  notifier.deleteScanTask(widget.taskId);
                  context.pushReplacement(AppRoutes.addMedicine);
                },
              ),
            SizedBox(height: 32.h),
          ],
        ),
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

  Widget _buildMedicationCard(Map<String, dynamic> med) {
    final String name = med['name'] ?? 'Không xác định';
    final String genericName = med['genericName'] ?? 'Thuốc cơ bản';
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
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0xFF5A5D7A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.moreHorizontal,
              color: Colors.white,
              size: 20.sp,
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
                    color: AppColors.typoHeading,
                  ),
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
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
