import '../entities/scan_task.dart';
import '../repositories/medication_repository.dart';

class ScanMedication {
  final MedicationRepository repository;
  ScanMedication(this.repository);

  Future<ScanTask> call({
    String? scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
    String? imagePath,
  }) {
    return repository.scan(
      scannedText: scannedText,
      shape: shape,
      rawData: rawData,
      imagePath: imagePath,
    );
  }
}
