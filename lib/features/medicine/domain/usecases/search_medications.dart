import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class SearchMedications {
  final MedicationRepository repository;
  SearchMedications(this.repository);

  Future<List<Medication>> call(String query) {
    return repository.searchMedications(query);
  }
}
