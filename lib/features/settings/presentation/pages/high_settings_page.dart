import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/high_settings/high_settings_provider.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/settings/settings_item_tile.dart';
import '../widgets/settings/settings_user_card.dart';
import '../widgets/settings/user_card_skeleton.dart';

class HighSettingsPage extends ConsumerWidget {
  const HighSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(highSettingsProvider);
    final notifier = ref.read(highSettingsProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              ProfileHeader(
                onBack: notifier.onBack,
                title: 'high_settings.title'.tr(),
                subtitle: 'high_settings.subtitle'.tr(),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // User card
                    if (state.isLoading && state.profile == null)
                      const UserCardSkeleton()
                    else if (state.profile != null)
                      SettingsUserCard(
                        username: state.profile?.displayName ?? 'User',
                        avatarUrl: state.profile?.avatarUrl,
                        onEditAvatar: () {},
                      ),

                    SizedBox(height: 24.h),

                    // Card container
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SettingsItemTile(
                            icon: LucideIcons.languages,
                            iconColor: const Color(0xFF4A90E2),
                            iconBg: const Color(0xFFF0F7FF),
                            labelKey: 'high_settings.language',
                            trailing: context.locale.languageCode == 'vi'
                                ? 'high_settings.vietnamese'.tr()
                                : 'high_settings.english'.tr(),
                            onTap: () => notifier.onLanguage(context),
                          ),
                          const SettingsDivider(),
                          SettingsItemTile(
                            icon: LucideIcons.lock,
                            iconColor: const Color(0xFF7E8CA0),
                            iconBg: const Color(0xFFF5F7FA),
                            labelKey: 'high_settings.change_password',
                            onTap: notifier.onChangePassword,
                          ),
                          const SettingsDivider(),
                          SettingsItemTile(
                            icon: LucideIcons.logOut,
                            iconColor: const Color(0xFFFF5252),
                            iconBg: const Color(0xFFFFF2F2),
                            labelKey: 'high_settings.logout',
                            isLogout: true,
                            showArrow: false,
                            onTap: () => notifier.onLogout(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
