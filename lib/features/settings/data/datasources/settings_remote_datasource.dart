import 'dart:io';

import '../api/settings_api.dart';
import '../models/family_member_model.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/notification_time.dart';

class SettingsRemoteDataSource {
  final SettingsApi _api;

  SettingsRemoteDataSource(this._api);

  Future<UserProfile> getProfile() {
    return _api.getProfile();
  }

  Future<UserProfile> updateProfile(UserProfile profile) {
    // Flattening for the current Backend DTO structure
    final data = {
      if (profile.fullName != null) 'fullName': profile.fullName,
      if (profile.dateOfBirth != null)
        'dateOfBirth': profile.dateOfBirth!.toUtc().toIso8601String(),
      if (profile.gender != null) 'gender': profile.gender?.toLowerCase(),
      if (profile.heightCm != null) 'heightCm': profile.heightCm,
      if (profile.weightKg != null) 'weightKg': profile.weightKg,
      if (profile.allergies != null) 'allergies': profile.allergies,
    };
    return _api.updateProfile(data);
  }

  Future<UserProfile> uploadAvatar(File file) async {
    final response = await _api.uploadAvatar(file);
    final newAvatarUrl =
        (response?['data'] as Map<String, dynamic>?)?['url'] as String?;

    final profile = await _api.getProfile();
    if (newAvatarUrl != null && newAvatarUrl.isNotEmpty) {
      return profile.copyWith(avatarUrl: newAvatarUrl);
    }
    return profile;
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _api.changePassword({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  /// Returns notification settings from API.
  Future<List<NotificationTime>> getNotificationSettings() async {
    final response = await _api.getNotificationTimeSlots();
    return response.data;
  }

  /// Returns the list of family members from the API.
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    final response = await _api.getUserRelationships();
    return response.data;
  }

  Future<String?> inviteMember(String email) async {
    final response = await _api.inviteMember({'email': email});
    final data = response.data as Map<String, dynamic>;
    // The link is inside the 'data' property of the standard API response helper
    final responseData = data['data'] as Map<String, dynamic>?;
    return responseData?['invitationLink'] as String?;
  }

  Future<void> acceptInvitation(String relationshipId) {
    return _api.acceptInvitation(relationshipId);
  }

  Future<void> acceptInvitationByToken(String token) {
    return _api.acceptInvitationByToken({'token': token});
  }
}
