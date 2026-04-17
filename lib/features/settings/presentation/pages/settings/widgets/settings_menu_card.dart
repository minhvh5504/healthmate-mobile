import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/settings/settings_notifier.dart';
import 'settings_item_tile.dart';

typedef SettingsMenuItem = ({
  String labelKey,
  IconData icon,
  void Function(SettingsNotifier) onTap,
});

final List<SettingsMenuItem> settingsMenuItems = [
  (
    labelKey: 'settings.basic_info',
    icon: Icons.person_outline_rounded,
    onTap: (n) => n.onBasicInfo(),
  ),
  (
    labelKey: 'settings.family_connect',
    icon: Icons.people_outline_rounded,
    onTap: (n) => n.onFamilyConnect(),
  ),
  (
    labelKey: 'settings.notifications',
    icon: Icons.notifications_none_rounded,
    onTap: (n) => n.onNotifications(),
  ),
  (
    labelKey: 'settings.advanced',
    icon: Icons.settings_outlined,
    onTap: (n) => n.onAdvanced(),
  ),
  (
    labelKey: 'settings.support',
    icon: Icons.help_outline_rounded,
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
              onTap: () => settingsMenuItems[i].onTap(notifier),
            ),
            if (i < settingsMenuItems.length - 1) const SettingsDivider(),
          ],
        ],
      ),
    );
  }
}
