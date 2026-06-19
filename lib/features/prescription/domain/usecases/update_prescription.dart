import 'dart:io';

import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

class UpdatePrescription {
  final PrescriptionRepository repository;
  UpdatePrescription(this.repository);

  Future<Prescription> call({
    required String id,
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
    String? status,
  }) {
    return repository.updatePrescription(
      id: id,
      doctorName: doctorName,
      clinicName: clinicName,
      note: note,
      startDate: startDate,
      endDate: endDate,
      imageFile: imageFile,
      status: status,
    );
  }
}
