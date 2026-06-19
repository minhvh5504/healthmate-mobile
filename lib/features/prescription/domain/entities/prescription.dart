class Prescription {
  final String id;
  final String doctorName;
  final String clinicName;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? note;

  const Prescription({
    required this.id,
    required this.doctorName,
    required this.clinicName,
    this.imageUrl,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.note,
  });

  Prescription copyWith({
    String? id,
    String? doctorName,
    String? clinicName,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? note,
  }) {
    return Prescription(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      clinicName: clinicName ?? this.clinicName,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      note: note ?? this.note,
    );
  }
}
