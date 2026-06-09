import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/user_provider.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/update_user_profile.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_info_bottom_sheet.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// State
class HealthState {
  final bool isLoading;
  final bool isAnalysisLoading;
  final UserProfile? userProfile;
  final HealthAnalysis? healthAnalysis;
  final String? errorMessage;
  final String weightDifference;
  final String heightDifference;

  const HealthState({
    this.isLoading = false,
    this.isAnalysisLoading = false,
    this.userProfile,
    this.healthAnalysis,
    this.errorMessage,
    this.weightDifference = '0',
    this.heightDifference = '0',
  });

  HealthState copyWith({
    bool? isLoading,
    bool? isAnalysisLoading,
    UserProfile? userProfile,
    HealthAnalysis? healthAnalysis,
    String? errorMessage,
    String? weightDifference,
    String? heightDifference,
  }) {
    return HealthState(
      isLoading: isLoading ?? this.isLoading,
      isAnalysisLoading: isAnalysisLoading ?? this.isAnalysisLoading,
      userProfile: userProfile ?? this.userProfile,
      healthAnalysis: healthAnalysis ?? this.healthAnalysis,
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
  final GetHealthAnalysis _getHealthAnalysis;
  final Ref _ref;

  HealthNotifier(
    this._getUserProfile,
    this._updateUserProfile,
    this._getHealthAnalysis,
    this._ref,
  ) : super(const HealthState()) {
    fetchProfile();
  }

  /// Format date for health popups
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
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
    switch (status?.toUpperCase()) {
      case 'UNDERWEIGHT':
        return const Color(0xFF60A5FA);
      case 'NORMAL':
        return const Color(0xFF10B981);
      case 'OVERWEIGHT':
        return const Color(0xFFFBBF24);
      case 'OBESE':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  /// Format peer description (e.g., 'Average for males under 18' -> 'NAM, DƯỚI 18 TUỔI')
  static String formatPeerDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'health.peer_analysis'.tr();
    }

    // Patterns from backend health_benchmarks table
    final underRegex = RegExp(
      r'Average for (males|females) under (\d+)',
      caseSensitive: false,
    );
    final rangeRegex = RegExp(
      r'Average for (males|females) (\d+)-(\d+)',
      caseSensitive: false,
    );

    var match = underRegex.firstMatch(description);
    if (match != null) {
      final gender = match.group(1)?.toLowerCase();
      final age = match.group(2);
      final genderKey = gender == 'males'
          ? 'health.benchmarks.male'
          : 'health.benchmarks.female';
      return 'health.benchmarks.under'.tr(args: [genderKey.tr(), age ?? '']);
    }

    match = rangeRegex.firstMatch(description);
    if (match != null) {
      final gender = match.group(1)?.toLowerCase();
      final ageStart = match.group(2);
      final ageEnd = match.group(3);
      final genderKey = gender == 'males'
          ? 'health.benchmarks.male'
          : 'health.benchmarks.female';
      return 'health.benchmarks.between'.tr(
        args: [genderKey.tr(), ageStart ?? '', ageEnd ?? ''],
      );
    }

    return description;
  }

  /// Get assessment text based on higher/lower/normal status
  static String getAssessmentStatusText(String? status) {
    switch (status) {
      case 'HIGHER':
        return 'health.status_higher';
      case 'LOWER':
        return 'health.status_lower';
      case 'NORMAL':
        return 'health.status_normal';
      default:
        return '---';
    }
  }

  /// Get peer comparison status text
  static String getPeerStatusText(String? status) {
    switch (status) {
      case 'HIGHER':
        return 'health.higher_than_average';
      case 'LOWER':
        return 'health.lower_than_average';
      case 'NORMAL':
        return 'health.normal_than_average';
      default:
        return 'health_metrics.bmi_status_unknown';
    }
  }

  /// Get color for analysis status (higher/lower/normal)
  static Color getAnalysisStatusColor(String? status) {
    switch (status) {
      case 'HIGHER':
        return const Color(0xFFEF4444);
      case 'LOWER':
        return const Color(0xFF22C55E);
      case 'NORMAL':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  /// Get icon for analysis status
  static IconData? getAnalysisStatusIcon(String? status) {
    switch (status) {
      case 'HIGHER':
        return LucideIcons.arrowUp;
      case 'LOWER':
        return LucideIcons.arrowDown;
      case 'NORMAL':
        return LucideIcons.check;
      default:
        return null;
    }
  }

  /// Show weight info bottom sheet
  void onShowWeightInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HealthInfoBottomSheet(
        title: 'health.weight_info_title'.tr(),
        content: 'health.weight_info_content'.tr(),
      ),
    );
  }

  /// Show height info bottom sheet
  void onShowHeightInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HealthInfoBottomSheet(
        title: 'health.height_info_title'.tr(),
        content: 'health.height_info_content'.tr(),
      ),
    );
  }

  /// Fetch profile
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _getUserProfile();
      if (!mounted) return;

      _updateStateWithProfile(profile);
      await _ref.read(userProfileProvider.notifier).fetchProfile(force: true);
      await fetchHealthAnalysis();
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Fetch health analysis
  Future<void> fetchHealthAnalysis() async {
    state = state.copyWith(isAnalysisLoading: true);
    try {
      final analysis = await _getHealthAnalysis();
      if (!mounted) return;
      state = state.copyWith(
        healthAnalysis: analysis,
        isAnalysisLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isAnalysisLoading: false);
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

      await _updateUserProfile(updatedProfile);
      final profile = await _getUserProfile();
      if (!mounted) return;

      _updateStateWithProfile(profile);
      await _ref.read(userProfileProvider.notifier).fetchProfile(force: true);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Unified save & close logic for metric popups
  Future<void> saveMetric({
    required BuildContext context,
    double? height,
    double? weight,
  }) async {
    try {
      await updateHealthMetrics(height: height, weight: weight);
      if (!context.mounted) return;

      final error = state.errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      } else {
        Navigator.pop(context);
        await fetchHealthAnalysis();
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
