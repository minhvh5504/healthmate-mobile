import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dialog/not_found_dialog.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (context) => AccountNotFoundDialog(
            title: 'notifications.confirm_delete_title'.tr(),
            message: 'notifications.confirm_delete_message'.tr(),
            showIcon: false,
            primaryButtonText: 'dialog.confirm'.tr(),
            secondaryButtonText: 'dialog.cancel'.tr(),
            onPrimaryPressed: () {
              confirmed = true;
            },
            onSecondaryPressed: () {},
          ),
        );
        return confirmed;
      },
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28.sp),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.typoBlack,
                              ),
                            ),
                          ),
                          if (!notification.isRead) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(top: 4.h),
                              decoration: const BoxDecoration(
                                color: AppColors.bgSuccess,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatDateTime(
                          notification.sentAt ?? notification.scheduledFor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.typoBlack.withValues(alpha: 0.74),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.typoNavi.withValues(alpha: 0.82),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF6B66FF),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B66FF).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SvgPicture.asset(
        AppIcons.bell,
        width: 30.w,
        height: 30.w,
        colorFilter: const ColorFilter.mode(AppColors.bgWhite, BlendMode.srcIn),
      ),
    );
  }

  String _formatDateTime(DateTime time) {
    return DateFormat('MMM dd, yyyy | hh:mm a').format(time);
  }
}
