import 'family_member_model.dart';

class UserRelationshipResponse {
  final bool success;
  final String message;
  final List<FamilyMemberModel> data;

  UserRelationshipResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserRelationshipResponse.fromJson(Map<String, dynamic> json) {
    return UserRelationshipResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
                .map(
                  (e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}
