import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/routing/app_routes.dart';
import '../../theme/app_colors.dart';
import 'nav_bar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int initialIndex;
  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    const Color navBgColor = AppColors.typoNavi;
    const Color activeColor = AppColors.typoNaviButton;
    const Color inactiveColor = AppColors.typoWhite;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
            label: 'Trang chủ',
            isActive: initialIndex == 0,
            onTap: () => context.go(AppRoutes.home),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavBarItem(
            icon: LucideIcons.pill,
            label: 'Thuốc',
            isActive: initialIndex == 1,
            onTap: () => context.go(AppRoutes.medicine),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavBarItem(
            icon: LucideIcons.heart,
            label: 'Sức khỏe',
            isActive: initialIndex == 2,
            onTap: () => context.go(AppRoutes.health),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavBarItem(
            icon: LucideIcons.clipboardList,
            label: 'Lịch sử',
            isActive: initialIndex == 3,
            onTap: () => context.go(AppRoutes.history),
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }
}
