import '../api/notification_api.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final NotificationApi api;

  NotificationRemoteDataSource(this.api);

  Future<List<NotificationModel>> getNotifications({
    bool? isRead,
    String? type,
    String? search,
    int? limit,
    int? page,
  }) async {
    final response = await api.getNotifications(
      isRead: isRead,
      type: type,
      search: search,
      limit: limit,
      page: page,
    );
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['items'] ?? [];
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<void> markReadById(String id) async {
    await api.markAsRead(id);
  }

  Future<void> markReadAll() async {
    await api.markReadBulk({'all': true});
  }

  Future<void> deleteById(String id) async {
    await api.delete(id);
  }

  Future<void> deleteAll() async {
    await api.deleteBulk({'all': true});
  }
}
