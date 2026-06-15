import '../repositories/settings_repository.dart';

class RemoveRelationship {
  final SettingsRepository repository;

  RemoveRelationship(this.repository);

  Future<void> call(String relationshipId) {
    return repository.removeRelationship(relationshipId);
  }
}
