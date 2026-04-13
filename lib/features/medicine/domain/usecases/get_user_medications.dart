import '../entities/user_medication.dart';
import '../repositories/medication_repository.dart';

class GetUserMedications {
  final MedicationRepository repository;
  GetUserMedications(this.repository);

  Future<List<UserMedication>> call() {
    return repository.getUserMedications();
  }
}
