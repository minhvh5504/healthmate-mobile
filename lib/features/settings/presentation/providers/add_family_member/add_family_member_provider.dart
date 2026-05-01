import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/settings/domain/usecases/accept_invitation.dart';
import 'package:healthmate_mobile/features/settings/domain/usecases/invite_family_member.dart';
import 'package:healthmate_mobile/features/settings/presentation/providers/settings/settings_provider.dart';
import 'add_family_member_notifier.dart';

final inviteFamilyMemberUseCaseProvider = Provider<InviteFamilyMember>((ref) {
  return InviteFamilyMember(ref.read(settingsRepositoryProvider));
});

final acceptInvitationUseCaseProvider = Provider<AcceptInvitation>((ref) {
  return AcceptInvitation(ref.read(settingsRepositoryProvider));
});

/// Provider
final addFamilyMemberProvider =
    StateNotifierProvider<AddFamilyMemberNotifier, AddFamilyMemberState>((ref) {
      return AddFamilyMemberNotifier(ref);
    });
