import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/notifications/presentation/providers/notification_notifier.dart';
import '../../../domain/entities/notification_entity.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final NotificationNotifier notifier;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final sortedNotifications = [...notifications]
      ..sort((a, b) => b.scheduledFor.compareTo(a.scheduledFor));

    return ListView(
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      children: [
        for (final notification in sortedNotifications)
          NotificationCard(
            notification: notification,
            onTap: () => notifier.onTapNotification(notification),
            onDelete: () => notifier.delete(notification.id),
          ),
      ],
    );
  }
}
