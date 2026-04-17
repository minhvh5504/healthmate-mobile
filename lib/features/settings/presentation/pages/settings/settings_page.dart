import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/settings/settings_provider.dart';
import 'widgets/app_version_footer.dart';
import 'widgets/settings_close_button.dart';
import 'widgets/settings_menu_card.dart';
import 'widgets/settings_user_card.dart';
import 'widgets/user_card_skeleton.dart';
import '../../../../../core/providers/user_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Close btn
              SettingsCloseButton(onTap: notifier.onBack),
              SizedBox(height: 12.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // User card
                      if (profile == null && state.isLoading)
                        const UserCardSkeleton()
                      else
                        SettingsUserCard(
                          username: profile?.displayName ?? 'Joyer',
                          avatarUrl: profile?.avatarUrl,
                          onEditAvatar: notifier.onEditAvatar,
                        ),

                      SizedBox(height: 28.h),

                      // Menu card
                      SettingsMenuCard(notifier: notifier),

                      SizedBox(height: 32.h),

                      // Version footer
                      const AppVersionFooter(),

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
