import '../entities/medication.dart';

abstract class MedicationRepository {
  Future<List<Medication>> searchMedications(String query);
}
