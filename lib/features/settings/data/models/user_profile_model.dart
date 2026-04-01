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
    // Data is usually wrapped in json['data'] from your ResponseHelper.success
    final raw = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    
    // Extract nested profile object
    final profile = raw['profile'] as Map<String, dynamic>?;

    return UserProfileModel(
      id: raw['id']?.toString() ?? '',
      email: raw['email']?.toString() ?? '',
      avatarUrl: raw['avatarUrl']?.toString(),
      role: raw['role']?.toString(),
      emailVerified: raw['emailVerified'] as bool?,
      
      // Data from nested profile
      fullName: profile?['fullName']?.toString(),
      dateOfBirth: profile?['dateOfBirth'] != null 
          ? DateTime.tryParse(profile!['dateOfBirth'].toString()) 
          : null,
      gender: profile?['gender']?.toString(),
      heightCm: (profile?['heightCm'] as num?)?.toDouble(),
      weightKg: (profile?['weightKg'] as num?)?.toDouble(),
      allergies: profile?['allergies']?.toString(),
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
