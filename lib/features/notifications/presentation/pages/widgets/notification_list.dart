import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/notifications/presentation/providers/notification_notifier.dart';
import '../../../domain/entities/notification_entity.dart';
import 'notification_card.dart';
import 'notification_section_header.dart';

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
    // Group notifications by date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final grouped = <String, List<NotificationEntity>>{};

    for (var n in notifications) {
      final date = DateTime(
        n.scheduledFor.year,
        n.scheduledFor.month,
        n.scheduledFor.day,
      );
      String key;
      if (date == today) {
        key = 'notifications.today'.tr();
      } else {
        key = 'notifications.earlier'.tr();
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(n);
    }

    final keys = ['notifications.today'.tr(), 'notifications.earlier'.tr()];

    return ListView(
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        for (var key in keys)
          if (grouped.containsKey(key)) ...[
            NotificationSectionHeader(title: key),
            ...grouped[key]!.map(
              (n) => NotificationCard(
                notification: n,
                onTap: () => notifier.onTapNotification(n),
                onDelete: () => notifier.delete(n.id),
              ),
            ),
            SizedBox(height: 16.h),
          ],
      ],
    );
  }
}
