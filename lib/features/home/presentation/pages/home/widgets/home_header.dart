import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/notifications/presentation/providers/notification_provider.dart';

class HomeHeader extends ConsumerWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;
  final String? avatarUrl;
  final String? displayName;

  const HomeHeader({
    super.key,
    required this.onProfilePressed,
    required this.onNotificationPressed,
    this.avatarUrl,
    this.displayName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationProvider).unreadCount;
    final name = displayName?.trim().isNotEmpty == true
        ? displayName!.trim()
        : 'Joyer';

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                InkWell(
                  onTap: onProfilePressed,
                  borderRadius: BorderRadius.circular(24.r),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: avatarUrl != null && avatarUrl!.isNotEmpty
                                ? NetworkImage(avatarUrl!) as ImageProvider
                                : const AssetImage(
                                    'assets/images/user/avatar.png',
                                  ),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 2.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -2.h,
                        right: -4.w,
                        child: SvgPicture.asset(
                          'assets/icons/home/list.svg',
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'home.greeting'.tr(),
                          children: [
                            TextSpan(
                              text: name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.typoBody,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FF),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12.sp,
                              color: const Color(0xFF5D63F1),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'home.welcome'.tr(),
                              style: TextStyle(
                                color: const Color(0xFF5D63F1),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
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
          SizedBox(width: 12.w),

          InkWell(
            onTap: onNotificationPressed,
            borderRadius: BorderRadius.circular(28.r),
            child: Stack(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/home/bell.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.bgPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.w,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
