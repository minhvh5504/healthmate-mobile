import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

/// A single info row used in Basic Info page.
/// Shows a label on the left and a value with a chevron on the right.
class InfoRowTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const InfoRowTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label
            SizedBox(
              width: 90.w,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.typoBlack,
                ),
              ),
            ),

            // Value + chevron
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: value == '—'
                            ? AppColors.typoDisable
                            : AppColors.typoBody.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18.sp,
                    color: AppColors.typoDisable,
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

/// Thin divider between info rows — starts after label column
class InfoRowDivider extends StatelessWidget {
  const InfoRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.bgHover,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
