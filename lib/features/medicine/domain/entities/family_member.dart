class FamilyMember {
  final String id; // Relationship ID
  final String userId; // Other user ID
  final String name;
  final String email;
  final String? avatar;
  final String status;
  final bool isInviter;
  final DateTime? joinedAt;

  const FamilyMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.avatar,
    required this.status,
    required this.isInviter,
    this.joinedAt,
  });
}
