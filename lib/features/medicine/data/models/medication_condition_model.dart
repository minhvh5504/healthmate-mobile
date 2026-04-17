import '../../domain/entities/medication_condition.dart';

class MedicationConditionModel extends MedicationCondition {
  const MedicationConditionModel({
    required super.id,
    required super.slug,
    required super.name,
    super.icon,
  });

  factory MedicationConditionModel.fromJson(Map<String, dynamic> json) {
    return MedicationConditionModel(
      id: (json['id'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      name: (json['displayName'] ?? '').toString(),
      icon: (json['iconEmoji'] ?? json['icon']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'icon': icon,
  };
}
