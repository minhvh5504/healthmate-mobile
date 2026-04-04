import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SettingsItemTile extends StatelessWidget {
  final String labelKey;
  final String? label; // Literal label if provided
  final IconData icon;
  final Color? iconColor;
  final Color? iconBg;
  final String? trailing;
  final bool isLogout;
  final bool showArrow;
  final VoidCallback onTap;

  const SettingsItemTile({
    super.key,
    this.labelKey = '',
    this.label,
    required this.icon,
    this.iconColor,
    this.iconBg,
    this.trailing,
    this.isLogout = false,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            if (iconBg != null)
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 22.sp,
                  color: iconColor ?? AppColors.bgPrimary,
                ),
              )
            else
              Icon(icon, size: 22.sp, color: iconColor ?? AppColors.typoBody),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label ?? labelKey.tr(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: isLogout
                      ? const Color(0xFFFF5252)
                      : AppColors.typoBlack,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoBody.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 4.w),
            ],
            if (showArrow)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AppColors.typoDisable,
              ),
          ],
        ),
      ),
    );
  }
}

/// Divider between settings items
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.bgHover,
      indent: 52.w,
    );
  }
}
