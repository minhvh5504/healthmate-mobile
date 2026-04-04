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

  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : email.split('@').first;
}
