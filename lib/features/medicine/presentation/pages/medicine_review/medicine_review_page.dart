import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import 'widgets/medicine_review_action_buttons.dart';
import 'widgets/medicine_review_content.dart';
import 'widgets/medicine_review_header.dart';

class MedicineReviewPage extends StatelessWidget {
  final String? taskId;

  const MedicineReviewPage({super.key, this.taskId});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const MedicineReviewHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    child: MedicineReviewContent(taskId: taskId),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: MedicineReviewActionButtons(taskId: taskId),
      ),
    );
  }
}
