import 'dart:io';

import '../api/prescription_api.dart';
import '../models/prescription_model.dart';
import '../../domain/entities/prescription.dart';

class PrescriptionRemoteDataSource {
  final PrescriptionApi _api;

  PrescriptionRemoteDataSource(this._api);

  Future<List<Prescription>> getPrescriptions() async {
    final response = await _api.getPrescriptions();
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => PrescriptionModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  Future<void> deletePrescription(String id) async {
    await _api.deletePrescription(id);
  }

  Future<Prescription> createPrescription({
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
  }) async {
    final response = await _api.createPrescription(
      doctorName: doctorName,
      clinicName: clinicName,
      note: note,
      startDate: startDate.toIso8601String().split('T').first,
      endDate: endDate?.toIso8601String().split('T').first,
      file: imageFile,
    );
    final data = response['data'] as Map<String, dynamic>;
    return PrescriptionModel.fromJson(data).toEntity();
  }

  Future<Prescription> updatePrescription({
    required String id,
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
    String? status,
  }) async {
    final response = await _api.updatePrescription(
      id: id,
      doctorName: doctorName,
      clinicName: clinicName,
      note: note,
      startDate: startDate.toIso8601String().split('T').first,
      endDate: endDate?.toIso8601String().split('T').first,
      file: imageFile,
      status: status,
    );
    final data = response['data'] as Map<String, dynamic>;
    return PrescriptionModel.fromJson(data).toEntity();
  }
}
