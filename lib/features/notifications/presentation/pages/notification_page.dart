import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_provider.dart';
import '../providers/notification_notifier.dart';
import 'widgets/notification_empty_state.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_list.dart';
import 'widgets/notification_skeleton.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    final isInitialLoading = state.isLoading && state.notifications.isEmpty;
    final visibleNotifications = _filterNotifications(
      state.notifications,
      state.filter,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: isInitialLoading
              ? const NotificationSkeleton()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NotificationHeader(
                      notifier: notifier,
                      selectedFilter: state.filter,
                      onFilterChanged: notifier.setFilter,
                    ).animate().fadeIn(duration: 220.ms),
                    Expanded(
                      child: state.errorMessage != null
                          ? Center(
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : visibleNotifications.isEmpty
                          ? const NotificationEmptyState().animate().fadeIn(
                              duration: 220.ms,
                              delay: 60.ms,
                            )
                          : NotificationList(
                              notifications: visibleNotifications,
                              notifier: notifier,
                            ).animate().fadeIn(duration: 220.ms, delay: 60.ms),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<NotificationEntity> _filterNotifications(
    List<NotificationEntity> notifications,
    NotificationFilter filter,
  ) {
    if (filter == NotificationFilter.all) {
      return notifications;
    }

    final now = DateTime.now();
    return notifications.where((notification) {
      final scheduledFor = notification.scheduledFor;
      return scheduledFor.year == now.year &&
          scheduledFor.month == now.month &&
          scheduledFor.day == now.day;
    }).toList();
  }
}
