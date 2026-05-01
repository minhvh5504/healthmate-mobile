import '../repositories/settings_repository.dart';

class AcceptInvitation {
  final SettingsRepository repository;

  AcceptInvitation(this.repository);

  Future<void> call({String? relationshipId, String? token}) {
    if (token != null) {
      return repository.acceptInvitationByToken(token);
    }
    return repository.acceptInvitation(relationshipId!);
  }
}
