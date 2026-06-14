import 'dart:io';

import '../entities/family_connection.dart';
import '../entities/notification_time.dart';
import '../entities/user_profile.dart';

abstract interface class SettingsRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<UserProfile> uploadAvatar(File file);
  Future<List<NotificationTime>> getNotificationSettings();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<List<FamilyMember>> getFamilyMembers();
  Future<String?> inviteMember(String email);
  Future<void> acceptInvitation(String relationshipId);
  Future<void> acceptInvitationByToken(String token);
}
