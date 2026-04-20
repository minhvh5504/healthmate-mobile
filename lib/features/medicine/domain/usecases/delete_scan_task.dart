import '../repositories/medication_repository.dart';

class DeleteScanTask {
  final MedicationRepository repository;
  DeleteScanTask(this.repository);

  Future<void> call(String taskId) {
    return repository.deleteScanTask(taskId);
  }
}
