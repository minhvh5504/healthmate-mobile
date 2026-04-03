import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_notifier.dart';
import '../settings/settings_provider.dart'; // reuse getUserProfileUseCaseProvider

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ref.read(getUserProfileUseCaseProvider));
});
