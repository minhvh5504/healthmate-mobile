import 'dart:io';

import '../../domain/entities/prescription.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_remote_datasource.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remoteDataSource;

  PrescriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Prescription>> getPrescriptions() =>
      remoteDataSource.getPrescriptions();

  @override
  Future<void> deletePrescription(String id) =>
      remoteDataSource.deletePrescription(id);

  @override
  Future<Prescription> createPrescription({
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
  }) =>
      remoteDataSource.createPrescription(
        doctorName: doctorName,
        clinicName: clinicName,
        note: note,
        startDate: startDate,
        endDate: endDate,
        imageFile: imageFile,
      );

  @override
  Future<Prescription> updatePrescription({
    required String id,
    required String doctorName,
    required String clinicName,
    required String note,
    required DateTime startDate,
    DateTime? endDate,
    File? imageFile,
    String? status,
  }) =>
      remoteDataSource.updatePrescription(
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
