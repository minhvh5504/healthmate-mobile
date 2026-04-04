import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/settings_provider.dart';
import '../../../domain/usecases/get_family_members.dart';
import 'family_connection_notifier.dart';

/// USECASE PROVIDER
final getFamilyMembersUseCaseProvider = Provider<GetFamilyMembers>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetFamilyMembers(repository);
});

/// STATE NOTIFIER PROVIDER
final familyConnectionProvider =
    StateNotifierProvider<FamilyConnectionNotifier, FamilyConnectionState>((
      ref,
    ) {
      return FamilyConnectionNotifier(ref);
    });
