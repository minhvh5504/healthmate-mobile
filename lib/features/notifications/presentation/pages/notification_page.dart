import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/notification_provider.dart';
import 'widgets/notification_empty_state.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_list.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationHeader(notifier: notifier),
              Expanded(
                child: state.errorMessage != null
                    ? Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.notifications.isEmpty
                    ? const NotificationEmptyState()
                    : NotificationList(
                        notifications: state.notifications,
                        notifier: notifier,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
