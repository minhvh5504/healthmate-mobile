import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/routing/app_routes.dart';

import '../../../../../core/constants/strings.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/providers/user_provider.dart';

class SettingsState {
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({this.isLoading = false, this.errorMessage});

  SettingsState copyWith({bool? isLoading, String? errorMessage}) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// NOTIFIER
class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(const SettingsState()) {
    ref.read(userProfileProvider.notifier).fetchProfile();
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.medicine);
  }

  /// Handle Basic Info
  void onBasicInfo() {
    AppRouter.router.go(AppRoutes.profile);
  }

  /// Handle Family Connect
  void onFamilyConnect() {
    AppRouter.router.push(AppRoutes.familyConnection);
  }

  /// Handle Notifications
  void onNotifications() {
    AppRouter.router.go(AppRoutes.notificationSettings);
  }

  /// Handle Advanced
  void onAdvanced() {
    AppRouter.router.go(AppRoutes.highSettings);
  }

  /// Handle Support
  Future<void> onSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportLink,
      queryParameters: const {'subject': 'Contact for Support'},
    );

    final opened = await _tryLaunchSupportEmail(uri);
    if (opened) return;

    await _copySupportEmail();
  }

  Future<bool> _tryLaunchSupportEmail(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<void> _copySupportEmail() async {
    await Clipboard.setData(const ClipboardData(text: supportLink));
  }

  /// Handle Edit avatar
  void onEditAvatar() {}
}
