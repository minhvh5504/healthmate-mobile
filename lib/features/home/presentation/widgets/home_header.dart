import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;

  const HomeHeader({
    super.key,
    required this.onProfilePressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile & Menu
          InkWell(
            onTap: onProfilePressed,
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/user/avatar.png'),
                      fit: BoxFit.contain,
                    ),
                    border: Border.all(color: Colors.white, width: 2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1C1E),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Icon(
                      LucideIcons.menu,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          InkWell(
            onTap: onNotificationPressed,
            borderRadius: BorderRadius.circular(28.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icons/home/noti.png',
                width: 28.sp,
                height: 28.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
