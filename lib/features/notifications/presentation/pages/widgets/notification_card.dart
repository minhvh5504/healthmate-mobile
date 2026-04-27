import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28.sp),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.typoHeading,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatTime(
                                    notification.sentAt ??
                                        notification.scheduledFor,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.typoDisable,
                                  ),
                                ),
                                if (!notification.isRead) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          notification.body,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.typoBody,
                            height: 1.4,
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
      ),
    );
  }

  Widget _buildIcon() {
    Color bgColor;
    IconData iconData;

    switch (notification.type.toLowerCase()) {
      case 'medicine':
      case 'medication':
        bgColor = const Color(0xFFC5C8E9);
        iconData = Icons.medication;
        break;
      case 'security':
      case 'password':
        bgColor = const Color(0xFFFFB29D);
        iconData = Icons.lock;
        break;
      default:
        bgColor = AppColors.lightBlue;
        iconData = Icons.notifications;
    }

    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(iconData, color: Colors.white, size: 24.w),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays < 7) {
      return DateFormat('E, HH:mm').format(time);
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
