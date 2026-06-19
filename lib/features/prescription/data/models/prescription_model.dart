import '../../domain/entities/prescription.dart';

class PrescriptionModel {
  final String id;
  final String doctorName;
  final String clinicName;
  final String? imageUrl;
  final String startDate;
  final String? endDate;
  final bool isActive;
  final String? note;

  const PrescriptionModel({
    required this.id,
    required this.doctorName,
    required this.clinicName,
    this.imageUrl,
    required this.startDate,
    this.endDate,
    required this.isActive,
    this.note,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String? ?? '',
      clinicName: json['clinicName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      isActive: json['status'] == 'ACTIVE' || (json['isActive'] as bool? ?? false),
      note: json['note'] as String?,
    );
  }

  Prescription toEntity() {
    return Prescription(
      id: id,
      doctorName: doctorName,
      clinicName: clinicName,
      imageUrl: imageUrl,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      isActive: isActive,
      note: note,
    );
  }
}
