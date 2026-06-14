import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon is IconData)
              Icon(icon as IconData, color: inactiveColor, size: 24.sp)
            else if (icon is String)
              SvgPicture.asset(
                icon as String,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(inactiveColor, BlendMode.srcIn),
              )
            else
              const SizedBox.shrink(),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: inactiveColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.05,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isActive ? 24.w : 0,
              height: 2.h,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
