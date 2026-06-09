import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/bottom_nav_provider.dart';
import '../../routing/app_routes.dart';
import '../../theme/app_colors.dart';
import 'nav_bar_item.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int initialIndex;
  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleTap(String route) {
      ref.read(bottomNavVisibleProvider.notifier).state = true;
      context.go(route);
    }

    void handleAddMedicine() {
      ref.read(bottomNavVisibleProvider.notifier).state = true;
      context.push(AppRoutes.addMedicine);
    }

    const Color navBgColor = AppColors.typoNavi;
    const Color activeColor = AppColors.typoNaviButton;
    const Color inactiveColor = AppColors.typoWhite;
    const Color addColor = Color(0xFF4F46E5);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 64.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: navBgColor.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(40.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.typoBlack.withValues(alpha: 0.18),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: NavBarItem(
                        icon: LucideIcons.pill,
                        label: 'bottom_nav.medicine'.tr(),
                        isActive: initialIndex == 0,
                        onTap: () => handleTap(AppRoutes.medicine),
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                    Expanded(
                      child: NavBarItem(
                        icon: LucideIcons.heart,
                        label: 'bottom_nav.health'.tr(),
                        isActive: initialIndex == 1,
                        onTap: () => handleTap(AppRoutes.health),
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                    Expanded(
                      child: NavBarItem(
                        icon: LucideIcons.clipboardList,
                        label: 'bottom_nav.history'.tr(),
                        isActive: initialIndex == 2,
                        onTap: () => handleTap(AppRoutes.history),
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 18.w),
            GestureDetector(
              onTap: handleAddMedicine,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: addColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: addColor.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Icon(LucideIcons.plus, color: Colors.white, size: 34.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
