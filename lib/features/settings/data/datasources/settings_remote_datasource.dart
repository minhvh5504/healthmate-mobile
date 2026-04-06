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

  Future<void> updateNotificationTime(String id, String newTime) async {
    await _api.updateNotificationTimeSlot(id, {'defaultTime': newTime});
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
