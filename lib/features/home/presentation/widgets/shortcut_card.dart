import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class HomeShortcutCard extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? iconSize;
  final bool showIconContainer;

  const HomeShortcutCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.gradient,
    this.iconSize,
    this.showIconContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(2.w),
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
                    width: iconSize ?? 52.w,
                    height: iconSize ?? 52.h,
                    child: Center(child: icon),
                  ),
                ),

                SizedBox(
                  height: 44.h, // Fixed height for text area
                  child: Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBlack,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
