import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_read_by_id.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/delete_notification_by_id.dart';
import '../../domain/usecases/delete_all_notifications.dart';
import '../../../../core/services/socket_realtime_service.dart';
import '../../data/models/notification_model.dart';
import '../pages/widgets/notification_more_menu.dart';

enum NotificationFilter { all, today }

/// State
class NotificationState {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? errorMessage;
  final int unreadCount;
  final NotificationFilter filter;
  final NotificationEntity? latestRealtimeNotification;
  final int realtimeNotificationSerial;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.unreadCount = 0,
    this.filter = NotificationFilter.all,
    this.latestRealtimeNotification,
    this.realtimeNotificationSerial = 0,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? errorMessage,
    int? unreadCount,
    NotificationFilter? filter,
    NotificationEntity? latestRealtimeNotification,
    int? realtimeNotificationSerial,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      filter: filter ?? this.filter,
      latestRealtimeNotification:
          latestRealtimeNotification ?? this.latestRealtimeNotification,
      realtimeNotificationSerial:
          realtimeNotificationSerial ?? this.realtimeNotificationSerial,
    );
  }
}

/// Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  final GetNotifications _getNotifications;
  final MarkNotificationReadById _markNotificationReadById;
  final MarkAllNotificationsRead _markAllNotificationsRead;
  final DeleteNotificationById _deleteNotificationById;
  final DeleteAllNotifications _deleteAllNotifications;
  final SocketRealtimeService _realtimeService;

  StreamSubscription<Map<String, dynamic>>? _notificationSub;
  StreamSubscription<int>? _unreadCountSub;
  String? _lastRealtimeNotificationId;

  NotificationNotifier(
    this._getNotifications,
    this._markNotificationReadById,
    this._markAllNotificationsRead,
    this._deleteNotificationById,
    this._deleteAllNotifications,
    this._realtimeService,
  ) : super(NotificationState()) {
    fetchNotifications();
    _listenToRealtimeEvents();
  }

  /// Listen to real-time events from the server
  void _listenToRealtimeEvents() {
    _notificationSub = _realtimeService.onNotification.listen((data) {
      try {
        final newNotification = NotificationModel.fromJson(data);
        if (newNotification.id == _lastRealtimeNotificationId) return;
        _lastRealtimeNotificationId = newNotification.id;

        final updated = [newNotification, ...state.notifications];
        state = state.copyWith(
          notifications: updated,
          unreadCount: state.unreadCount + 1,
          latestRealtimeNotification: newNotification,
          realtimeNotificationSerial: state.realtimeNotificationSerial + 1,
        );
      } catch (e) {
        // Malformed payload
      }
    });

    _unreadCountSub = _realtimeService.onUnreadCount.listen((count) {
      state = state.copyWith(unreadCount: count);
    });
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    _unreadCountSub?.cancel();
    super.dispose();
  }

  /// Fetch notifications
  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Ensure skeleton stays visible for at least 300ms even if API
      // responds faster, to avoid flickering.
      final results = await Future.wait([
        _getNotifications(),
        Future<void>.delayed(const Duration(milliseconds: 300)),
      ]);
      final notifications = results[0] as List<NotificationEntity>;
      if (!mounted) return;
      state = state.copyWith(notifications: notifications, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Mark notification as read
  Future<void> markRead(String id) async {
    try {
      await _markNotificationReadById(id);
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.id == id) {
            return n.copyWith(isRead: true, readAt: DateTime.now());
          }
          return n;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Mark all notifications as read
  Future<void> markReadAll() async {
    try {
      await _markAllNotificationsRead();
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Delete notification
  Future<void> delete(String id) async {
    try {
      await _deleteNotificationById(id);
      state = state.copyWith(
        notifications: state.notifications.where((n) => n.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Delete all notifications
  Future<void> deleteAll() async {
    try {
      await _deleteAllNotifications();
      state = state.copyWith(notifications: []);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// UI Actions
  void setFilter(NotificationFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void onShowMoreMenu(BuildContext context) {
    NotificationMoreMenu.show(context).then((value) {
      if (value == 'mark_read') {
        markReadAll();
      } else if (value == 'delete_all') {
        deleteAll();
      }
    });
  }

  /// Handle notification tap
  void onTapNotification(NotificationEntity notification) {
    if (!notification.isRead) {
      markRead(notification.id);
    }
    // Handle actionUrl if present
    if (notification.actionUrl != null) {
      // navigation logic...
    }
  }
}
