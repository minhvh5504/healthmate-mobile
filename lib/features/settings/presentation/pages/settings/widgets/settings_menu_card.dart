import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/settings/settings_notifier.dart';
import 'settings_item_tile.dart';

typedef SettingsMenuItem = ({
  String labelKey,
  IconData icon,
  Color iconColor,
  void Function(SettingsNotifier) onTap,
});

final List<SettingsMenuItem> settingsMenuItems = [
  (
    labelKey: 'settings.basic_info',
    icon: Icons.person_rounded,
    iconColor: const Color(0xFF4A90E2),
    onTap: (n) => n.onBasicInfo(),
  ),
  (
    labelKey: 'settings.family_connect',
    icon: Icons.people_rounded,
    iconColor: const Color(0xFF7F66FF),
    onTap: (n) => n.onFamilyConnect(),
  ),
  (
    labelKey: 'settings.notifications',
    icon: Icons.notifications_rounded,
    iconColor: const Color(0xFFFF9F0A),
    onTap: (n) => n.onNotifications(),
  ),
  (
    labelKey: 'settings.advanced',
    icon: Icons.settings_rounded,
    iconColor: const Color(0xFF7E8CA0),
    onTap: (n) => n.onAdvanced(),
  ),
  (
    labelKey: 'settings.support',
    icon: Icons.help_rounded,
    iconColor: const Color(0xFF34C759),
    onTap: (n) => n.onSupport(),
  ),
];

class SettingsMenuCard extends StatelessWidget {
  final SettingsNotifier notifier;
  const SettingsMenuCard({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < settingsMenuItems.length; i++) ...[
            SettingsItemTile(
              labelKey: settingsMenuItems[i].labelKey,
              icon: settingsMenuItems[i].icon,
              iconColor: settingsMenuItems[i].iconColor,
              onTap: () => settingsMenuItems[i].onTap(notifier),
            ),
            if (i < settingsMenuItems.length - 1) const SettingsDivider(),
          ],
        ],
      ),
    );
  }
}
