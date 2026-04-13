import '../repositories/medication_repository.dart';

class CreateUserMedication {
  final MedicationRepository repository;
  CreateUserMedication(this.repository);

  Future<void> call({
    required String medicationId,
    Map<String, dynamic>? scannedData,
  }) {
    return repository.createUserMedication(
      medicationId: medicationId,
      scannedData: scannedData,
    );
  }
}
