import '../entities/family_member.dart';
import '../repositories/medication_repository.dart';

class GetFamilyMembers {
  final MedicationRepository repository;

  GetFamilyMembers(this.repository);

  Future<List<FamilyMember>> call() async {
    return repository.getUserRelationships();
  }
}
