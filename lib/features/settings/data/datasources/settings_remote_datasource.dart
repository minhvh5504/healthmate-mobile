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

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _api.changePassword({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  /// Returns notification settings from API.
  Future<List<NotificationTime>> getNotificationSettings() async {
    return _api.getNotificationTimeSlots();
  }

  /// Returns a mocked list of family members.
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      const FamilyMemberModel(
        id: '1',
        name: 'Joyer5504',
        avatar:
            'https://ui-avatars.com/api/?name=Joyer5504&background=0D8ABC&color=fff',
      ),
    ];
  }
}
