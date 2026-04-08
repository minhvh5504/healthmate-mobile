import '../../domain/entities/medication.dart';

class MedicationModel extends Medication {
  const MedicationModel({
    required super.id,
    required super.name,
    super.genericName,
    super.manufacturer,
    super.dosageForm,
    super.strength,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      genericName: json['genericName']?.toString(),
      manufacturer: json['manufacturer']?.toString(),
      dosageForm: json['dosageForm']?.toString(),
      strength: json['strength']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'genericName': genericName,
        'manufacturer': manufacturer,
        'dosageForm': dosageForm,
        'strength': strength,
      };
}
