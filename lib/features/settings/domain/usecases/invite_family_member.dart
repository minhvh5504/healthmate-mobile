import '../repositories/settings_repository.dart';

class InviteFamilyMember {
  final SettingsRepository repository;

  InviteFamilyMember(this.repository);

  Future<String?> call(String email) {
    return repository.inviteMember(email);
  }
}
