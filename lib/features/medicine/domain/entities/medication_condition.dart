class MedicationCondition {
  final String id;
  final String slug;
  final String name;
  final String? icon;

  const MedicationCondition({
    required this.id,
    required this.slug,
    required this.name,
    this.icon,
  });
}
