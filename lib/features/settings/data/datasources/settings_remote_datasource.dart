import '../api/settings_api.dart';
import '../../domain/entities/user_profile.dart';

class SettingsRemoteDataSource {
  final SettingsApi _api;

  SettingsRemoteDataSource(this._api);

  Future<UserProfile> getProfile() {
    return _api.getProfile();
  }
}
