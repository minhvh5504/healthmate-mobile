import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../providers/medicine_flow/medicine_flow_provider.dart';
import '../../../providers/medicine_review/medicine_review_provider.dart';
import 'medicine_review_card.dart';

class MedicineReviewContent extends ConsumerStatefulWidget {
  final String? taskId;

  const MedicineReviewContent({super.key, this.taskId});

  @override
  ConsumerState<MedicineReviewContent> createState() =>
      _MedicineReviewContentState();
}

class _MedicineReviewContentState extends ConsumerState<MedicineReviewContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.taskId != null) {
        ref.read(medicineProvider.notifier).selectTaskForReview(widget.taskId!);
      } else {
        final flowData = ref.read(medicineFlowProvider).toMap();
        ref.read(medicineReviewProvider.notifier).init(flowData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBatchReview = widget.taskId != null;
    final medicineState = ref.watch(medicineProvider);
    final reviewState = ref.watch(medicineReviewProvider);

    final medications = isBatchReview
        ? medicineState.reviewMedications
        : (reviewState.medication.isNotEmpty ? [reviewState.medication] : []);

    final isEmpty = medications.isEmpty;
    final imagePath = isBatchReview ? medicineState.reviewImagePath : null;

    return Column(
      children: [
        if (isBatchReview && imagePath != null) ...[
          Center(
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Thêm thuốc vào hộp! Vui lòng kiểm tra lại thông tin để tránh sai sót.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: const CircularProgressIndicator(),
          )
        else
          ...medications.map(
            (med) => MedicineReviewCard(medication: med, isCentered: false),
          ),
        SizedBox(height: 120.h),
      ],
    );
  }
}
