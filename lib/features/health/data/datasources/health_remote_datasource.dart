import 'package:healthmate_mobile/features/health/data/api/health_api.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';

class HealthRemoteDataSource {
  final HealthApi _api;

  HealthRemoteDataSource(this._api);

  Future<UserProfile> getProfile() {
    return _api.getProfile();
  }

  Future<UserProfile> updateProfile(UserProfile profile) {
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
}
