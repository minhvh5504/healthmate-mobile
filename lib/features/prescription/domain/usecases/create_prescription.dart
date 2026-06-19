import 'dart:io';

import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

class CreatePrescription {
  final PrescriptionRepository repository;
  CreatePrescription(this.repository);

  Future<Prescription> call({
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
  }) {
    return repository.createPrescription(
      doctorName: doctorName,
      clinicName: clinicName,
      note: note,
      startDate: startDate,
      endDate: endDate,
      imageFile: imageFile,
    );
  }
}
