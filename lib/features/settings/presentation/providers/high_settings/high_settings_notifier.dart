import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_profile.dart';
import '../../widgets/settings/logout_dialog.dart';
import '../../widgets/settings/language_dialog.dart';
import '../../../../auth/presentation/providers/auth/auth_provider.dart';
import '../settings/settings_provider.dart';

/// STATE
class HighSettingsState {
  final UserProfile? profile;
  final bool isLoading;
  final String? errorMessage;
  final String locale;

  const HighSettingsState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
    this.locale = 'vi',
  });

  HighSettingsState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
    String? locale,
  }) {
    return HighSettingsState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      locale: locale ?? this.locale,
    );
  }
}

/// NOTIFIER
class HighSettingsNotifier extends StateNotifier<HighSettingsState> {
  final Ref ref;

  HighSettingsNotifier(this.ref) : super(const HighSettingsState()) {
    loadProfile();
  }

  /// Load profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final getUserProfile = ref.read(getUserProfileUseCaseProvider);
      final profile = await getUserProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.settings);
  }

  /// Handle Language
  void onLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LanguageDialog(
        title: 'high_settings.language'.tr(),
        currentLocale: context.locale.languageCode,
        onClose: ctx.pop,
        options: [
          LanguageOption(name: 'high_settings.vietnamese'.tr(), locale: 'vi'),
          LanguageOption(name: 'high_settings.english'.tr(), locale: 'en'),
        ],
        onSelect: (localeCode) {
          context.setLocale(Locale(localeCode));
          state = state.copyWith(locale: localeCode);
          ctx.pop();
        },
      ),
    );
  }

  /// Handle Change Password
  void onChangePassword() {
    AppRouter.router.go(AppRoutes.changepassword);
  }

  /// Handle Logout
  void onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LogoutDialog(
        title: 'logout_dialog.title'.tr(),
        message: 'logout_dialog.message'.tr(),
        confirmText: 'logout_dialog.confirm'.tr(),
        cancelText: 'logout_dialog.cancel'.tr(),
        onCancel: ctx.pop,
        onConfirm: () async {
          final prefs = await SharedPreferences.getInstance();
          final loginType = prefs.getString('login_type');

          if (loginType == 'google') {
            final googleSignIn = GoogleSignIn.instance;
            try {
              await googleSignIn.disconnect();
            } catch (_) {
              await googleSignIn.signOut();
            }
            await FirebaseAuth.instance.signOut();
          }

          await ref.read(authProvider.notifier).logout();

          AppRouter.router.go(AppRoutes.splash);
        },
      ),
    );
  }
}
