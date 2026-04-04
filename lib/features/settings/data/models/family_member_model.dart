import '../../domain/entities/family_connection.dart';

/// Data model for [FamilyMember] with JSON serialization.
class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.id,
    required super.name,
    super.avatar,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
  };
}
