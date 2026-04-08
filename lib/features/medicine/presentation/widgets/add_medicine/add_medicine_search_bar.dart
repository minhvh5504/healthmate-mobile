import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_colors.dart';

class AddMedicineSearchBar extends StatelessWidget {
  const AddMedicineSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.onCancel,
    this.showCancel = false,
    this.showClear = true,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final VoidCallback? onCancel;
  final bool showCancel;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(color: AppColors.lightPurple),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightPurple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Icon(LucideIcons.search,
                      color: AppColors.typoHeading, size: 20.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoHeading,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.typoBody.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  if (showClear &&
                      controller != null &&
                      controller!.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        controller!.clear();
                        onChanged('');
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Icon(
                          LucideIcons.xCircle,
                          color: AppColors.typoBody.withOpacity(0.3),
                          size: 20.w,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 16.w),
                ],
              ),
            ),
          ),
          if (showCancel) ...[
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onCancel,
              child: Text(
                'common.cancel'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700, // Đậm như trong thiết kế
                  color: AppColors.typoHeading,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
