import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/routing/app_router.dart';
import '../../../../core/config/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_item_tile.dart';
import '../widgets/settings_user_card.dart';


// Menu type
typedef _MenuItem = ({String labelKey, IconData icon, String route});

// Static items
const List<_MenuItem> _menuItems = [
  (
    labelKey: 'settings.basic_info',
    icon: Icons.person_outline_rounded,
    route: '/settings/basic-info',
  ),
  (
    labelKey: 'settings.family_connect',
    icon: Icons.people_outline_rounded,
    route: '/settings/family',
  ),
  (
    labelKey: 'settings.notifications',
    icon: Icons.notifications_none_rounded,
    route: AppRoutes.notifications,
  ),
  (
    labelKey: 'settings.advanced',
    icon: Icons.settings_outlined,
    route: '/settings/advanced',
  ),
  (
    labelKey: 'settings.support',
    icon: Icons.help_outline_rounded,
    route: '/settings/support',
  ),
];


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Close btn
              _CloseButton(onTap: notifier.onBack),
              SizedBox(height: 12.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // User card
                      if (state.isLoading && state.profile == null)
                        const _UserCardSkeleton()
                      else
                        SettingsUserCard(
                          username: state.profile?.displayName ?? 'Joyer',
                          avatarUrl: state.profile?.avatarUrl,
                          onEditAvatar: () {},
                        ),

                      SizedBox(height: 28.h),

                      // Menu card
                      const _SettingsMenuCard(),

                      SizedBox(height: 32.h),

                      // Version footer
                      _AppVersionFooter(),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Back button
class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, top: 8.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50.r),
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.close_rounded,
              size: 18.sp,
              color: AppColors.typoBlack,
            ),
          ),
        ),
      ),
    );
  }
}

// Menu card
class _SettingsMenuCard extends StatelessWidget {
  const _SettingsMenuCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _menuItems.length; i++) ...[
            SettingsItemTile(
              labelKey: _menuItems[i].labelKey,
              icon: _menuItems[i].icon,
              onTap: () => AppRouter.router.push(_menuItems[i].route),
            ),
            if (i < _menuItems.length - 1) const SettingsDivider(),
          ],
        ],
      ),
    );
  }
}

// App footer
class _AppVersionFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'settings.app_version'.tr(),
          style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.typoDisable),
        ),
        SizedBox(height: 2.h),
        Text(
          '© 2026 HealthMate',
          style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.typoDisable),
        ),
      ],
    );
  }
}

// Loading skeleton
class _UserCardSkeleton extends StatelessWidget {
  const _UserCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgHover,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: 120.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.bgHover,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 160.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: AppColors.bgHover,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ],
    );
  }
}
