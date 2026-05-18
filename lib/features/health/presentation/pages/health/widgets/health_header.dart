import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/core/providers/user_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HealthHeader extends ConsumerWidget {
  const HealthHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthNotifier = ref.read(healthProvider.notifier);
    final profile = ref.watch(userProfileProvider);
    final avatarUrl = profile?.avatarUrl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile & Menu
          InkWell(
            onTap: healthNotifier.onProfile,
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: avatarUrl != null && avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl) as ImageProvider
                          : const AssetImage('assets/images/user/avatar.png'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1C1E),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Icon(
                      LucideIcons.menu,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          InkWell(
            onTap: healthNotifier.onNotification,
            borderRadius: BorderRadius.circular(28.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/home/bell.svg',
                width: 28.sp,
                height: 28.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.bgPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
