import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';

class HomeShortcutCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final Widget icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? iconWidth;
  final double? iconHeight;
  final bool showIconContainer;

  const HomeShortcutCard({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.gradient,
    this.iconWidth,
    this.iconHeight,
    this.showIconContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 120.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B7280).withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(gradient == null ? 8.w : 0),
                  decoration: showIconContainer
                      ? BoxDecoration(
                          color: gradient == null
                              ? const Color(0xFFF0FDF4)
                              : null,
                          gradient: gradient,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: SizedBox(
                    width: iconWidth ?? 42.w,
                    height: iconHeight ?? 42.w,
                    child: Center(child: icon),
                  ),
                ),

                SizedBox(height: 9.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.typoBlack,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 5.h),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.typoBody,
                      height: 1.18,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
