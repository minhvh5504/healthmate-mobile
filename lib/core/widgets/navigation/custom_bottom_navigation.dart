import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/routing/app_routes.dart';
import '../../theme/app_colors.dart';
import 'nav_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int initialIndex;
  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    const Color navBgColor = AppColors.typoNavi;
    const Color activeColor = AppColors.typoNaviButton;
    const Color inactiveColor = AppColors.typoWhite;

    return ColoredBox(
      color: initialIndex == 0 ? Colors.white : Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: navBgColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              icon: LucideIcons.home,
              label: 'bottom_nav.home'.tr(),
              isActive: initialIndex == 0,
              onTap: () => context.go(AppRoutes.home),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            NavBarItem(
              icon: LucideIcons.pill,
              label: 'bottom_nav.medicine'.tr(),
              isActive: initialIndex == 1,
              onTap: () => context.go(AppRoutes.medicine),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            NavBarItem(
              icon: LucideIcons.heart,
              label: 'bottom_nav.health'.tr(),
              isActive: initialIndex == 2,
              onTap: () => context.go(AppRoutes.health),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            NavBarItem(
              icon: LucideIcons.clipboardList,
              label: 'bottom_nav.history'.tr(),
              isActive: initialIndex == 3,
              onTap: () => context.go(AppRoutes.history),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
