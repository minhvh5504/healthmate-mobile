import '../entities/medication.dart';
import '../entities/user_medication.dart';
import '../entities/scan_task.dart';

abstract class MedicationRepository {
  Future<List<Medication>> searchMedications(String query);
  Future<ScanTask> scan({
    required String scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
  });

  Future<List<ScanTask>> getScanTasks();
  Future<void> deleteScanTask(String id);

  Future<void> createUserMedication({
    required String medicationId,
    Map<String, dynamic>? scannedData,
  });

  Future<void> updateUserMedication({
    required String id,
    bool? isActive,
    String? dosage,
  });

  Future<List<UserMedication>> getUserMedications();
}
