import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../prescription/widgets/prescription_skeleton.dart';

class ViewAllPrescriptionSkeleton extends StatelessWidget {
  const ViewAllPrescriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const PrescriptionHistoryItemSkeleton()
            .animate()
            .fadeIn(duration: 220.ms, delay: (60 * index).ms);
      },
    );
  }
}
