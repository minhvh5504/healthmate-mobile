import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/domain/entities/user_profile.dart';
import '../../features/settings/presentation/providers/settings/settings_provider.dart';

/// A global provider that holds the user profile.
/// This acts as the single source of truth to avoid redundant API calls.
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;
  bool _isLoading = false;

  UserProfileNotifier(this.ref) : super(null);

  Future<void> fetchProfile({bool force = false}) async {
    if (_isLoading) return;
    if (state != null && !force) return;

    _isLoading = true;
    try {
      final useCase = ref.read(getUserProfileUseCaseProvider);
      final profile = await useCase();
      state = profile;
    } catch (e) {
      // Handle error or silent fail
    } finally {
      _isLoading = false;
    }
  }

  void updateProfile(UserProfile profile) {
    state = profile;
  }
}
