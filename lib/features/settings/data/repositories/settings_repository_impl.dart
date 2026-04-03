import '../../domain/entities/notification_time.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserProfile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<List<NotificationTime>> getNotificationSettings() {
    return localDataSource.getNotificationSettings();
  }

  @override
  Future<void> updateNotificationTime(String id, String newTime) {
    return localDataSource.updateNotificationTime(id, newTime);
  }
}
