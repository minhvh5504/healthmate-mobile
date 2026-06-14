import 'dart:io';

import '../entities/user_profile.dart';
import '../repositories/settings_repository.dart';

class UploadUserAvatar {
  final SettingsRepository repository;

  UploadUserAvatar(this.repository);

  Future<UserProfile> call(File file) {
    return repository.uploadAvatar(file);
  }
}
