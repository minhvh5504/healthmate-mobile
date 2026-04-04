import '../../domain/entities/family_connection.dart';
import '../../domain/repositories/settings_repository.dart';

class GetFamilyMembers {
  final SettingsRepository _repository;

  GetFamilyMembers(this._repository);

  Future<List<FamilyMember>> call() => _repository.getFamilyMembers();
}
