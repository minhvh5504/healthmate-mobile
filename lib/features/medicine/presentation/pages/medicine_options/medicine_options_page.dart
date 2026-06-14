import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/user_medication.dart';
import 'widgets/medicine_options_card.dart';
import 'widgets/medicine_options_icon.dart';
import 'widgets/medicine_options_label.dart';
import 'widgets/medicine_options_title.dart';

class MedicineOptionsPage extends StatelessWidget {
  final UserMedication? medication;

  const MedicineOptionsPage({super.key, this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Dim
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

          // Popup Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Close Button
                    Positioned(
                      top: 16.h,
                      right: 16.w,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          LucideIcons.x,
                          color: AppColors.typoBody.withValues(alpha: 0.4),
                          size: 24.sp,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MedicineOptionsTitle(medication: medication),
                          SizedBox(height: 16.h),
                          const MedicineOptionsIcon(),
                          SizedBox(height: 4.h),
                          MedicineOptionsLabel(medication: medication),
                          SizedBox(height: 32.h),
                          MedicineOptionsCard(medication: medication),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
