import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_time.dart';
import '../providers/notifications/setting_noti_provider.dart';
import '../providers/notifications/setting_noti_notifier.dart';

import '../../../../core/widgets/header/profile_header.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingNotiProvider);
    final notifier = ref.read(settingNotiProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Use ProfileHeader with only onBack for this screen
                    ProfileHeader(onBack: () => notifier.onBack()),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),

                            // Notification Section Header
                            _buildSectionHeader(
                              Icons.notifications_active_rounded,
                              'settings.notifications'.tr(),
                            ),
                            SizedBox(height: 16.h),

                            // Main Notification Controls Card
                            _buildNotificationControls(state, notifier),

                            SizedBox(height: 32.h),

                            // Time Settings Section Header
                            _buildSectionHeader(
                              Icons.access_time_filled_rounded,
                              'settings.noti_time_settings'.tr(),
                            ),
                            Text(
                              'settings.noti_time_desc'.tr(),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                color: AppColors.typoBody.withOpacity(0.6),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Time Settings List Card
                            _buildTimeSettingsCard(state, notifier),

                            SizedBox(height: 40.h),
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

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.typoBlack),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationControls(
    SettingNotiState state,
    SettingNotiNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enable Notifications
          _buildControlTile(
            icon: Icons.notifications_rounded,
            iconColor: Colors.orange,
            title: 'settings.enable_notifications'.tr(),
            trailing: InkWell(
              onTap: () =>
                  notifier.toggleNotifications(!state.isNotificationsEnabled),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: state.isNotificationsEnabled
                      ? AppColors.lineButton
                      : LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade500],
                        ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: state.isNotificationsEnabled
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7F66FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  state.isNotificationsEnabled
                      ? 'settings.on'.tr()
                      : 'settings.off'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Sound Notifications
          _buildControlTile(
            icon: Icons.volume_up_rounded,
            iconColor: const Color(0xFF6366F1),
            title: 'settings.sound_notifications'.tr(),
            trailing: Switch.adaptive(
              value: state.isSoundEnabled,
              onChanged: notifier.toggleSound,
              activeColor: const Color(0xFF34D399),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(icon, color: iconColor, size: 24.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoBlack,
            ),
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildTimeSettingsCard(
    SettingNotiState state,
    SettingNotiNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.notificationTimes.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = state.notificationTimes[index];
          return _buildTimeTile(item, index);
        },
      ),
    );
  }

  Widget _buildTimeTile(NotificationTime item, int index) {
    final List<Color> safeColors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Wait, violet...
      const Color(0xFF0EA5E9), // Sky Blue
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFF43F5E), // Rose
    ];

    final Color iconColor = safeColors[index % safeColors.length];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _getIconBySlug(item.slug),
              color: iconColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              item.title.tr(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              item.time,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconBySlug(String slug) {
    switch (slug) {
      case 'before_breakfast':
        return Icons.wb_sunny_rounded;
      case 'after_breakfast':
        return Icons.sunny_snowing;
      case 'before_lunch':
        return Icons.wb_sunny;
      case 'after_lunch':
        return Icons.wb_twilight_rounded;
      case 'before_dinner':
        return Icons.wb_sunny_outlined;
      case 'after_dinner':
        return Icons.dark_mode_rounded;
      case 'before_sleep':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_filled_rounded;
    }
  }
}
