import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../providers/medicine/medicine_provider.dart';
import 'widgets/review_medication_card.dart';
import 'widgets/delete_scan_task_popup.dart';

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
        leadingWidth: 60.w,
        leading: Center(
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: AppColors.typoBlack,
              ),
            ),
          ),
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
              ...medications.map<Widget>(
                (med) => ReviewMedicationCard(medication: med),
              ),

            SizedBox(height: 70.h),
            Button(
              text: 'Xóa tất cả thuốc',
              textColor: Colors.red,
              color: Colors.white,
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Delete Confirmation',
                  barrierColor: Colors.black.withValues(alpha: 0.2),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, anim1, anim2) {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: AppColors.backgroundGradient,
                              ),
                            ),
                          ),
                          Center(
                            child: DeleteScanTaskPopup(
                              onConfirm: () {
                                notifier.deleteScanTask(widget.taskId);
                                context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return FadeTransition(opacity: anim1, child: child);
                  },
                );
              },
              height: 48.h,
              width: double.infinity,
            ),
            SizedBox(height: 8.h),
            if (medications.isNotEmpty)
              Button(
                text: 'Thêm vào hộp thuốc',
                onPressed: () {
                  notifier.saveMedicinesToCabinet(widget.taskId);
                  context.pop();
                },
                height: 48.h,
                width: double.infinity,
              )
            else
              Button(
                text: 'Thêm thủ công',
                onPressed: () {
                  notifier.deleteScanTask(widget.taskId);
                  context.pushReplacement(
                    AppRoutes.medicineDetailPreview,
                    extra: {'name': ''},
                  );
                },
                height: 48.h,
                width: double.infinity,
              ),
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
}
