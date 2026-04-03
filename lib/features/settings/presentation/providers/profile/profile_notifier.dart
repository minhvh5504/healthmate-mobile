import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/get_user_profile.dart';

/// STATE
class ProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({this.profile, this.isLoading = false, this.errorMessage});

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// NOTIFIER
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfile _getUserProfile;

  ProfileNotifier(this._getUserProfile) : super(const ProfileState()) {
    loadProfile();
  }

  /// Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _getUserProfile();
      if (!mounted) return;
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Navigate back
  void onBack() => AppRouter.router.go(AppRoutes.settings);

  /// Format gender
  static String formatGender(String? gender) {
    if (gender == null) return '—';
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return gender;
    }
  }

  /// Format date
  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void onEditFullName() {}

  void onEditGender() {}

  void onEditBirthDate() {}

  void onEditHeight() {}

  void onEditWeight() {}

  void onEditEmail() {}
}
