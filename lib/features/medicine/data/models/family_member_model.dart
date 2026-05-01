import '../../domain/entities/family_member.dart';

class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.email,
    super.avatar,
    required super.status,
    required super.isInviter,
    super.joinedAt,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    final otherUser = json['otherUser'] as Map<String, dynamic>? ?? {};

    return FamilyMemberModel(
      id: json['id']?.toString() ?? '',
      userId: otherUser['id']?.toString() ?? '',
      name:
          otherUser['fullName']?.toString() ??
          otherUser['email']?.toString() ??
          '',
      email: otherUser['email']?.toString() ?? '',
      avatar: otherUser['avatarUrl']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      isInviter: json['isInviter'] as bool? ?? false,
      joinedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'].toString())
          : (json['invitedAt'] != null
                ? DateTime.tryParse(json['invitedAt'].toString())
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'isInviter': isInviter,
      'otherUser': {
        'id': userId,
        'email': email,
        'fullName': name,
        'avatarUrl': avatar,
      },
    };
  }

  static List<FamilyMemberModel> fromJsonList(List<dynamic> json) {
    return json
        .map((e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
