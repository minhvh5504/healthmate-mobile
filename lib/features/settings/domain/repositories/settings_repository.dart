import '../entities/notification_time.dart';
import '../entities/user_profile.dart';

abstract interface class SettingsRepository {
  Future<UserProfile> getProfile();
  Future<List<NotificationTime>> getNotificationSettings();
  Future<void> updateNotificationTime(String id, String newTime);
  Future<void> changePassword(String currentPassword, String newPassword);
}
