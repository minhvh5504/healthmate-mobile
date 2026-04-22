import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/update_user_profile.dart';

/// State
class HealthState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;
  final String weightDifference;
  final String heightDifference;

  const HealthState({
    this.isLoading = false,
    this.userProfile,
    this.errorMessage,
    this.weightDifference = '0',
    this.heightDifference = '0',
  });

  HealthState copyWith({
    bool? isLoading,
    UserProfile? userProfile,
    String? errorMessage,
    String? weightDifference,
    String? heightDifference,
  }) {
    return HealthState(
      isLoading: isLoading ?? this.isLoading,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage ?? this.errorMessage,
      weightDifference: weightDifference ?? this.weightDifference,
      heightDifference: heightDifference ?? this.heightDifference,
    );
  }
}

/// Notifier
class HealthNotifier extends StateNotifier<HealthState> {
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;

  HealthNotifier(this._getUserProfile, this._updateUserProfile)
    : super(const HealthState()) {
    fetchProfile();
  }

  /// Map BMI Status to i18n key
  static String formatBMIStatus(String? status) {
    if (status == null || status.trim().isEmpty || status == 'unknown') {
      return 'health_metrics.bmi_status_unknown'.tr();
    }

    switch (status.toUpperCase()) {
      case 'UNDERWEIGHT':
        return 'health_metrics.bmi_status_underweight'.tr();
      case 'NORMAL':
        return 'health_metrics.bmi_status_normal'.tr();
      case 'OVERWEIGHT':
        return 'health_metrics.bmi_status_overweight'.tr();
      case 'OBESE':
        return 'health_metrics.bmi_status_obese'.tr();
      default:
        return status;
    }
  }

  /// Get color based on BMI Status
  static Color getBMIColor(String? status) {
    if (status == null || status.trim().isEmpty) return const Color(0xFF34C759);

    switch (status.toUpperCase()) {
      case 'UNDERWEIGHT':
        return const Color(0xFF007AFF); // Blue
      case 'NORMAL':
        return const Color(0xFF34C759); // Green
      case 'OVERWEIGHT':
        return const Color(0xFFFF9500); // Orange
      case 'OBESE':
        return const Color(0xFFFF3B30); // Red
      default:
        return const Color(0xFF34C759);
    }
  }

  /// Fetch profile
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _getUserProfile();
      if (!mounted) return;

      _updateStateWithProfile(profile);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update profile
  Future<void> updateHealthMetrics({double? height, double? weight}) async {
    if (state.userProfile == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedProfile = state.userProfile!.copyWith(
        heightCm: height,
        weightKg: weight,
      );

      final result = await _updateUserProfile(updatedProfile);
      if (!mounted) return;

      _updateStateWithProfile(result);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _updateStateWithProfile(UserProfile profile) {
    final delta = profile.healthDelta;

    final weightDiff = _formatDiff(delta?.weightKg ?? 0);
    final heightDiff = _formatDiff(delta?.heightCm ?? 0);

    state = state.copyWith(
      userProfile: profile,
      weightDifference: weightDiff,
      heightDifference: heightDiff,
      isLoading: false,
    );
  }

  String _formatDiff(double diff) {
    if (diff == 0) return '0';
    final sign = diff > 0 ? '+' : '';
    return '$sign${diff % 1 == 0 ? diff.toInt() : diff.toStringAsFixed(1)}';
  }

  /// Handle change weight
  void onChangeWeight() {
    // Show bottom sheet to update weight
  }

  /// Handle change height
  void onChangeHeight() {
    // Show bottom sheet to update height
  }

  /// Handle change BMI
  void onChangeBMI() {
    // Show bottom sheet to update BMI
  }

  /// Handle on tap profile
  void onProfile() {}

  /// Handle on tap notification
  void onNotification() {}
}
