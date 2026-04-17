import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/config/routing/app_routes.dart';
import '../../../../../../core/theme/app_colors.dart';

class ReviewMedicationCard extends StatelessWidget {
  final Map<String, dynamic> medication;

  const ReviewMedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final String name = medication['name'] ?? 'Không xác định';
    final String genericName = medication['genericName'] ?? 'Thuốc cơ bản';

    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.medicineDetailPreview, extra: medication),
      child: Container(
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
      ),
    );
  }
}
