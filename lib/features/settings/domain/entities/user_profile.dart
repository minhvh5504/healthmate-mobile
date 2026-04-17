class UserProfile {
  final String id;
  final String email;
  final String? avatarUrl;
  final String? role;
  final bool? emailVerified;
  final String? fullName;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? allergies;

  const UserProfile({
    required this.id,
    required this.email,
    this.avatarUrl,
    this.role,
    this.emailVerified,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.allergies,
  });

  UserProfile copyWith({
    String? id,
    String? email,
    String? avatarUrl,
    String? role,
    bool? emailVerified,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? allergies,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      allergies: allergies ?? this.allergies,
    );
  }

  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : email.split('@').first;

  double? get bmi {
    if (heightCm == null || weightKg == null || heightCm! <= 0) return null;
    final heightMeters = heightCm! / 100;
    return weightKg! / (heightMeters * heightMeters);
  }

  String get bmiStatus {
    final value = bmi;
    if (value == null) return 'unknown';
    if (value < 18.5) return 'underweight';
    if (value < 25) return 'normal';
    if (value < 30) return 'overweight';
    return 'obese';
  }
}
