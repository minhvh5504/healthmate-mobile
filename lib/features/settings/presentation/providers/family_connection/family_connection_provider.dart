import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_provider.dart';
import '../../../domain/usecases/get_family_members.dart';
import '../../../domain/usecases/accept_invitation.dart';
import 'family_connection_notifier.dart';

/// Usecase
final getFamilyMembersUseCaseProvider = Provider<GetFamilyMembers>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetFamilyMembers(repository);
});

final acceptInvitationUseCaseProvider = Provider<AcceptInvitation>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return AcceptInvitation(repository);
});

/// Provider
final familyConnectionProvider =
    StateNotifierProvider<FamilyConnectionNotifier, FamilyConnectionState>((
      ref,
    ) {
      return FamilyConnectionNotifier(ref);
    });
