import '../entities/family_connection.dart';
import '../entities/notification_time.dart';
import '../entities/user_profile.dart';

abstract interface class SettingsRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<List<NotificationTime>> getNotificationSettings();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<List<FamilyMember>> getFamilyMembers();
}
