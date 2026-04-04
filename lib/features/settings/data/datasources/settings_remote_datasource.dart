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

  /// Returns notification settings. Currently mocked.
  Future<List<NotificationTime>> getNotificationSettings() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _notificationTimes;
  }

  // Mocked storage for notification times
  List<NotificationTime> _notificationTimes = const [
    NotificationTime(
      id: 'before_breakfast',
      title: 'settings.before_breakfast',
      time: '07:00',
      iconPath: 'images/icons/sun.png',
    ),
    NotificationTime(
      id: 'after_breakfast',
      title: 'settings.after_breakfast',
      time: '08:00',
      iconPath: 'images/icons/sun_up.png',
    ),
    NotificationTime(
      id: 'before_lunch',
      title: 'settings.before_lunch',
      time: '11:00',
      iconPath: 'images/icons/sun_bright.png',
    ),
    NotificationTime(
      id: 'after_lunch',
      title: 'settings.after_lunch',
      time: '13:00',
      iconPath: 'images/icons/sun_noon.png',
    ),
    NotificationTime(
      id: 'before_dinner',
      title: 'settings.before_dinner',
      time: '17:00',
      iconPath: 'images/icons/sunset.png',
    ),
    NotificationTime(
      id: 'after_dinner',
      title: 'settings.after_dinner',
      time: '19:00',
      iconPath: 'images/icons/moon_light.png',
    ),
    NotificationTime(
      id: 'before_sleep',
      title: 'settings.before_sleep',
      time: '22:00',
      iconPath: 'images/icons/moon.png',
    ),
  ];
  Future<void> updateNotificationTime(String id, String newTime) async {
    _notificationTimes = _notificationTimes.map((item) {
      if (item.id == id) {
        return item.copyWith(time: newTime);
      }
      return item;
    }).toList();
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
