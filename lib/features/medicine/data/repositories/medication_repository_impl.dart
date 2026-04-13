import '../../domain/entities/medication.dart';
import '../../domain/entities/user_medication.dart';
import '../../domain/entities/scan_task.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_datasource.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;

  MedicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Medication>> searchMedications(String query) {
    return remoteDataSource.searchMedications(query);
  }

  @override
  Future<ScanTask> scan({
    required String scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
  }) {
    return remoteDataSource.scan(
      scannedText: scannedText,
      shape: shape,
      rawData: rawData,
    );
  }

  @override
  Future<List<ScanTask>> getScanTasks() {
    return remoteDataSource.getScanTasks();
  }

  @override
  Future<void> deleteScanTask(String id) {
    return remoteDataSource.deleteScanTask(id);
  }

  @override
  Future<void> createUserMedication({
    required String medicationId,
    Map<String, dynamic>? scannedData,
  }) {
    return remoteDataSource.createUserMedication(
      medicationId: medicationId,
      scannedData: scannedData,
    );
  }

  @override
  Future<void> updateUserMedication({
    required String id,
    bool? isActive,
    String? dosage,
  }) {
    return remoteDataSource.updateUserMedication(
      id: id,
      data: {
        if (isActive != null) 'isActive': isActive,
        if (dosage != null) 'dosage': dosage,
      },
    );
  }

  @override
  Future<List<UserMedication>> getUserMedications() {
    return remoteDataSource.getUserMedications();
  }
}
