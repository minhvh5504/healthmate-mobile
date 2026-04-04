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
  Future<List<NotificationTime>> getNotificationSettings() {
    return remoteDataSource.getNotificationSettings();
  }

  @override
  Future<void> updateNotificationTime(String id, String newTime) {
    return remoteDataSource.updateNotificationTime(id, newTime);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return remoteDataSource.changePassword(currentPassword, newPassword);
  }

  @override
  Future<List<FamilyMember>> getFamilyMembers() {
    return remoteDataSource.getFamilyMembers();
  }
}
