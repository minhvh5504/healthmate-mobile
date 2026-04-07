import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/update_user_profile.dart';
import '../../widgets/profile/profile_edit_popups.dart';

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
  final UpdateUserProfile _updateUserProfile;

  ProfileNotifier(this._getUserProfile, this._updateUserProfile)
    : super(const ProfileState()) {
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

  void handleUpdateBirthDate(DateTime newValue) {
    if (state.profile == null) return;
    updateProfile(state.profile!.copyWith(dateOfBirth: newValue));
  }

  /// Update profile field
  Future<void> updateProfile(UserProfile updatedProfile) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _updateUserProfile(updatedProfile);
      if (!mounted) return;
      await loadProfile();
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void handleUpdateFullName(String newValue) {
    if (state.profile == null) return;
    updateProfile(state.profile!.copyWith(fullName: newValue));
  }

  void handleUpdateGender(String newValue) {
    if (state.profile == null) return;
    updateProfile(state.profile!.copyWith(gender: newValue));
  }

  void onEditFullName(BuildContext context) {
    if (state.profile == null) return;
    ProfileEditPopups.showNameEdit(
      context,
      initialValue: state.profile!.fullName ?? '',
      onSave: handleUpdateFullName,
    );
  }

  void onEditGender(BuildContext context) {
    if (state.profile == null) return;
    ProfileEditPopups.showGenderEdit(
      context,
      initialValue: state.profile!.gender,
      onSave: handleUpdateGender,
    );
  }

  void onEditBirthDate(BuildContext context) {
    if (state.profile == null) return;
    ProfileEditPopups.showBirthdayEdit(
      context,
      initialValue: state.profile!.dateOfBirth,
      onSave: handleUpdateBirthDate,
    );
  }
}
