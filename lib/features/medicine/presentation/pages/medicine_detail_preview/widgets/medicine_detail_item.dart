import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final Color? titleColor;
  final EdgeInsets? padding;

  const MedicineDetailItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
    this.titleColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: titleColor ?? AppColors.bgDisable, size: 24.sp),
            SizedBox(width: 8.w),
            if (value != null && value!.isNotEmpty)
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? AppColors.typoBlack,
                  ),
                ),
              )
            else
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? AppColors.typoBlack,
                  ),
                ),
              ),
            if (value != null && value!.isNotEmpty)
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        value!,
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.typoBlack,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.typoBody.withValues(alpha: 0.3),
                      size: 20.sp,
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.typoBody.withValues(alpha: 0.3),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
