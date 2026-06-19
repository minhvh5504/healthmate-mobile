import 'dart:io';

import '../entities/prescription.dart';

abstract class PrescriptionRepository {
  Future<List<Prescription>> getPrescriptions();
  Future<void> deletePrescription(String id);
  Future<Prescription> createPrescription({
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
  });
  Future<Prescription> updatePrescription({
    required String id,
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
    String? status,
  });
}
