import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_notifier.dart';
import '../settings/settings_provider.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/update_user_profile.dart';

/// UseCase update profile
final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  return GetUserProfile(ref.read(settingsRepositoryProvider));
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  return UpdateUserProfile(ref.read(settingsRepositoryProvider));
});

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(
    ref.read(getUserProfileUseCaseProvider),
    ref.read(updateUserProfileUseCaseProvider),
    ref,
  );
});
