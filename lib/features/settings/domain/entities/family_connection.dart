
/// Core domain entity for a family member.
class FamilyMember {
  /// Unique identifier.
  final String id;
  /// Display name.
  final String name;
  /// Optional avatar URL.
  final String? avatar;

  const FamilyMember({
    required this.id,
    required this.name,
    this.avatar,
  });
}
