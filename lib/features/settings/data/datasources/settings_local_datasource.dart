import '../../domain/entities/notification_time.dart';

abstract interface class SettingsLocalDataSource {
  Future<List<NotificationTime>> getNotificationSettings();
  Future<void> updateNotificationTime(String id, String newTime);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  // Fake data moved here
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

  @override
  Future<List<NotificationTime>> getNotificationSettings() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _notificationTimes;
  }

  @override
  Future<void> updateNotificationTime(String id, String newTime) async {
    _notificationTimes = _notificationTimes.map((item) {
      if (item.id == id) {
        return item.copyWith(time: newTime);
      }
      return item;
    }).toList();
  }
}
