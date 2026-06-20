import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/socket_realtime_provider.dart';
import 'package:healthmate_mobile/features/auth/presentation/providers/auth/auth_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/api/notification_api.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_read_by_id.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/delete_notification_by_id.dart';
import '../../domain/usecases/delete_all_notifications.dart';
import 'notification_notifier.dart';

/// API Provider
final notificationApiProvider = Provider<NotificationApi>((ref) {
  return ApiClient(ref).create(NotificationApi.new);
});

/// Data Source Provider
final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSource(ref.read(notificationApiProvider));
    });

/// Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.read(notificationRemoteDataSourceProvider),
  );
});

/// Usecases
final getNotificationsUseCaseProvider = Provider<GetNotifications>((ref) {
  return GetNotifications(ref.read(notificationRepositoryProvider));
});

final markNotificationReadByIdUseCaseProvider =
    Provider<MarkNotificationReadById>((ref) {
      return MarkNotificationReadById(ref.read(notificationRepositoryProvider));
    });

final markAllNotificationsReadUseCaseProvider =
    Provider<MarkAllNotificationsRead>((ref) {
      return MarkAllNotificationsRead(ref.read(notificationRepositoryProvider));
    });

final deleteNotificationByIdUseCaseProvider = Provider<DeleteNotificationById>((
  ref,
) {
  return DeleteNotificationById(ref.read(notificationRepositoryProvider));
});

final deleteAllNotificationsUseCaseProvider = Provider<DeleteAllNotifications>((
  ref,
) {
  return DeleteAllNotifications(ref.read(notificationRepositoryProvider));
});

/// Notifier Provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final isLoggedIn = ref.watch(
        authProvider.select((state) => state.isLoggedIn),
      );

      return NotificationNotifier(
        ref.read(getNotificationsUseCaseProvider),
        ref.read(markNotificationReadByIdUseCaseProvider),
        ref.read(markAllNotificationsReadUseCaseProvider),
        ref.read(deleteNotificationByIdUseCaseProvider),
        ref.read(deleteAllNotificationsUseCaseProvider),
        ref.read(realtimeServiceProvider),
        shouldFetch: isLoggedIn,
      );
    });
