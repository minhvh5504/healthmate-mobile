import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SettingsUserCard extends StatelessWidget {
  final String username;
  final String? avatarUrl;
  final VoidCallback? onEditAvatar;

  const SettingsUserCard({
    super.key,
    required this.username,
    this.avatarUrl,
    this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with camera badge
        Stack(
          alignment: Alignment.center,
          children: [
            // Avatar circle
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.bgPrimary.withValues(alpha: 0.2),
                  width: 3,
                ),
                color: AppColors.bgHover,
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _DefaultAvatar(),
                      )
                    : const _DefaultAvatar(),
              ),
            ),

            // Camera badge
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditAvatar,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Username
        Text(
          username,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBlack,
          ),
        ),

        SizedBox(height: 4.h),

        // Member badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/setting/health.png',
              width: 16.w,
              height: 16.w,
            ),
            SizedBox(width: 4.w),
            Text.rich(
              TextSpan(
                text: 'settings.member_of'.tr(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  color: AppColors.typoBody,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'HealthMate',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bgPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Avatar fallback
class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/user/avatar.png', fit: BoxFit.cover);
  }
}
