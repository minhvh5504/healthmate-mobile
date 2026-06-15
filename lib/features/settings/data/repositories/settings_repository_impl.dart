import 'dart:io';

import '../../domain/entities/family_connection.dart';
import '../../domain/entities/notification_time.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return remoteDataSource.updateProfile(profile);
  }

  @override
  Future<UserProfile> uploadAvatar(File file) {
    return remoteDataSource.uploadAvatar(file);
  }

  @override
  Future<List<NotificationTime>> getNotificationSettings() {
    return remoteDataSource.getNotificationSettings();
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return remoteDataSource.changePassword(currentPassword, newPassword);
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() {
    return remoteDataSource.getFamilyMembers();
  }

  @override
  Future<String?> inviteMember(String email) {
    return remoteDataSource.inviteMember(email);
  }

  @override
  Future<void> acceptInvitation(String relationshipId) {
    return remoteDataSource.acceptInvitation(relationshipId);
  }

  @override
  Future<void> acceptInvitationByToken(String token) {
    return remoteDataSource.acceptInvitationByToken(token);
  }

  @override
  Future<void> removeRelationship(String relationshipId) {
    return remoteDataSource.removeRelationship(relationshipId);
  }
}
