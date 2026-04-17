import '../entities/medication_condition.dart';
import '../repositories/medication_repository.dart';

class GetMedicationConditions {
  final MedicationRepository repository;

  GetMedicationConditions(this.repository);

  Future<List<MedicationCondition>> call() async {
    return repository.getMedicationConditions();
  }
}
