class Medication {
  final String id;
  final String name;
  final String? genericName;
  final String? manufacturer;
  final String? dosageForm;
  final String? dosage;
  final String? unit;

  const Medication({
    required this.id,
    required this.name,
    this.genericName,
    this.manufacturer,
    this.dosageForm,
    this.dosage,
    this.unit,
  });
}
