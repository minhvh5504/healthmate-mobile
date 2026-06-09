import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.avatarUrl,
    super.role,
    super.emailVerified,
    super.fullName,
    super.dateOfBirth,
    super.gender,
    super.heightCm,
    super.weightKg,
    super.allergies,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;

    final profile = raw['profile'] as Map<String, dynamic>?;
    final pSource = profile ?? raw;

    return UserProfileModel(
      id: raw['userId']?.toString() ?? raw['id']?.toString() ?? '',
      email: raw['email']?.toString() ?? '',
      avatarUrl: raw['avatarUrl']?.toString() ?? raw['avatar_url']?.toString(),
      role: raw['role']?.toString(),
      emailVerified:
          raw['emailVerified'] as bool? ?? raw['email_verified'] as bool?,

      fullName:
          pSource['fullName']?.toString() ?? pSource['full_name']?.toString(),
      dateOfBirth: (pSource['dateOfBirth'] ?? pSource['date_of_birth']) != null
          ? DateTime.tryParse(
              (pSource['dateOfBirth'] ?? pSource['date_of_birth']).toString(),
            )
          : null,
      gender: pSource['gender']?.toString(),
      heightCm: double.tryParse(
        pSource['heightCm']?.toString() ??
            pSource['height_cm']?.toString() ??
            '',
      ),
      weightKg: double.tryParse(
        pSource['weightKg']?.toString() ??
            pSource['weight_kg']?.toString() ??
            '',
      ),
      allergies: pSource['allergies']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'avatarUrl': avatarUrl,
    'role': role,
    'emailVerified': emailVerified,
    'profile': {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'allergies': allergies,
    },
  };
}
