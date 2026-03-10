import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../config/routing/app_routes.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int initialIndex;
  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: initialIndex,
      onTap: (index) {
        if (index == 0) context.go(AppRoutes.home);
        if (index == 1) context.go(AppRoutes.profile);
        if (index == 2) context.go(AppRoutes.settings);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
