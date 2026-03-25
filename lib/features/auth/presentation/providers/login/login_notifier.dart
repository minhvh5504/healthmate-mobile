// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart' as gs;

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/previous_page_provider.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../../../core/widgets/dialog/not_found_dialog.dart';
import '../../../domain/usecases/login_account.dart';
import '../../../domain/usecases/login_with_google.dart';
import '../auth/auth_provider.dart';

/// STATE
class LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool remember;
  final bool emailValid;
  final bool passwordValid;
  final bool hasEmailError;
  final bool hasPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    required this.emailController,
    required this.passwordController,
    this.remember = false,
    this.emailValid = false,
    this.passwordValid = false,
    this.hasEmailError = false,
    this.hasPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? remember,
    bool? emailValid,
    bool? passwordValid,
    bool? hasEmailError,
    bool? hasPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      emailController: emailController,
      passwordController: passwordController,
      remember: remember ?? this.remember,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// NOTIFIER
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginAccount _loginUseCase;
  final LoginWithGoogle _loginWithGoogleUseCase;
  final Ref ref;

  LoginNotifier(this._loginUseCase, this._loginWithGoogleUseCase, this.ref)
    : super(
        LoginState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ) {
    _loadSavedAccount();
    state.emailController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
  }

  /// Load saved credentials from SharedPreferences
  Future<void> _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_username') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    state.emailController.text = savedEmail;
    state.passwordController.text = savedPassword;
    state = state.copyWith(remember: remember);
    _validateAll();
  }

  /// Validate all input fields
  void _validateAll() {
    final emailText = state.emailController.text.trim();
    final passText = state.passwordController.text.trim();

    // true = valid
    final emailValid = Validation.isValidEmail(emailText);
    final passwordValid = Validation.isStrongPassword(passText);

    // true = form valid
    final valid = emailValid && passwordValid;

    state = state.copyWith(
      // true = valid input
      emailValid: emailValid,
      passwordValid: passwordValid,

      // true = show red border
      hasEmailError: !emailValid && emailText.isNotEmpty,
      hasPasswordError: !passwordValid && passText.isNotEmpty,

      // true = enable submit button
      isValid: valid,
    );
  }

  /// Get error text
  String? get emailErrorText {
    final text = state.emailController.text.trim();

    if (text.isEmpty) return null;

    if (!Validation.isValidEmail(text)) {
      return 'login.error_invalid_email'.tr();
    }

    return null;
  }

  /// Get error text
  String? get passwordErrorText {
    final text = state.passwordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'login.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'login.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'login.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'login.error_password_special'.tr();
    }

    return null;
  }

  /// Toggle remember
  void toggleRemember(bool? value) {
    state = state.copyWith(remember: value ?? false);
  }

  /// Set loading state
  void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading, errorMessage: null);
  }

  /// Navigate to Onboarding page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.onboarding);
  }

  /// Navigate to Forgot Password page
  void onForgotPassword(BuildContext context) {
    context.go(AppRoutes.sendrequest);
  }

  /// Handle sign-in process
  Future<void> onSignIn(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    _setLoading(true);

    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();

    try {
      final user = await _loginUseCase(email, password);
      await ref
          .read(authProvider.notifier)
          .login(
            accessToken: user.accessToken,
            refreshToken: user.refreshToken,
          );

      await _handleLoginSuccess(context, email, password);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  /// Handle Continue with Google
  Future<void> onContinueWithGoogle(BuildContext context) async {
    if (state.isLoading) return;

    _setLoading(true);

    try {
      final gSignIn = gs.GoogleSignIn.instance;
      await gSignIn.initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? dotenv.env['IOS_CLIENT_ID']
            : null,
        serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
      );

      final googleUser = await gSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw Exception('Failed to get ID token from Google');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Firebase login failed');

      final firebaseIdToken = await firebaseUser.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        throw Exception('Firebase token missing');
      }

      final authUser = await _loginWithGoogleUseCase(firebaseIdToken);

      await ref
          .read(authProvider.notifier)
          .login(
            accessToken: authUser.accessToken,
            refreshToken: authUser.refreshToken,
          );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('login_type', 'google');

      _setLoading(false);

      if (context.mounted) {
        context.pop();
        context.go(AppRoutes.home);
      }
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  /// Handle successful login
  Future<void> _handleLoginSuccess(
    BuildContext context,
    String username,
    String password,
  ) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_type', 'api');

    if (state.remember) {
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }

    _setLoading(false);

    context.go(AppRoutes.home);
  }

  /// Handle failure
  void _handleFailure(BuildContext context, Object error) {
    // Handle cancellation
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('sign_in_canceled') ||
        errorString.contains('canceled') ||
        errorString.contains('12501')) {
      _setLoading(false);
      return;
    }

    String errorMessage = 'Unknown error';
    String? errorCode;

    if (error is DioException) {
      final response = error.response;
      final data = response?.data;

      if (data is Map<String, dynamic>) {
        errorCode = (data['errorCode'] ?? data['messageCode'])?.toString();
        errorMessage =
            (data['errorMessage'] ?? data['message'])?.toString() ??
            errorMessage;
      } else if (data is String) {
        errorMessage = data;
      } else {
        errorMessage = error.message ?? errorMessage;
      }
    } else {
      errorMessage = error.toString();
    }

    final translatedMessage = _translateError(errorCode ?? errorMessage);
    state = state.copyWith(isLoading: false, errorMessage: translatedMessage);

    _showAuthErrorDialog(
      context: context,
      errorCode: errorCode,
      errorMessage: errorMessage,
      message: translatedMessage,
    );
  }

  /// Show error dialog
  void _showAuthErrorDialog({
    required BuildContext context,
    String? errorCode,
    required String errorMessage,
    required String message,
  }) {
    final isNotVerified =
        errorCode == 'AUTH.ACCOUNT_NOT_VERIFIED' ||
        errorMessage.contains('Please verify your email address first') ||
        errorMessage.contains('User not verified');

    final isAccountDisabled =
        errorCode == 'AUTH.ACCOUNT_DISABLED' ||
        errorMessage.contains(
          'Your account has been deactivated/blocked by admin',
        );

    final isNotFound =
        errorCode == 'AUTH.USER_NOT_FOUND' ||
        errorCode == 'AUTH.INVALID_CREDENTIALS' ||
        errorMessage.contains('User not found') ||
        errorMessage.contains('Email or password is incorrect') ||
        errorCode == '401';

    if (isNotFound) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AccountNotFoundDialog(
          title: 'login.user_not_found_dialog.title'.tr(),
          message: 'login.user_not_found_dialog.message'.tr(),
          primaryButtonText: 'login.user_not_found_dialog.primary_button'.tr(),
          secondaryButtonText: 'login.user_not_found_dialog.secondary_button'
              .tr(),
          onPrimaryPressed: () {
            ref.read(previousPageProvider.notifier).state = 'login';
            context.go(AppRoutes.register);
          },
          onSecondaryPressed: () {
            state.emailController.clear();
            state.passwordController.clear();
          },
        ),
      );
      return;
    }

    if (isAccountDisabled) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ConfirmDialog(message: message, onTap: () {}),
      );
      return;
    }

    if (isNotVerified) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ConfirmDialog(
          message: message,
          onTap: () {
            ref.read(previousPageProvider.notifier).state = 'login';
            context.go(AppRoutes.verifyaccount);
          },
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(message: message, onTap: () {}),
    );
  }

  // Translate error messages
  String _translateError(String error) {
    final cleanError = error.replaceFirst('Exception: ', '').trim();

    if (cleanError == 'AUTH.INVALID_CREDENTIALS' ||
        cleanError == 'Invalid credentials' ||
        cleanError == 'Email or password is incorrect' ||
        cleanError == 'Phone number/email or password is incorrect' ||
        cleanError == 'Wrong credentials') {
      return 'login.errors.wrong_credentials'.tr();
    }

    if (cleanError == 'AUTH.ACCOUNT_DISABLED' ||
        cleanError == 'Your account has been deactivated/blocked by admin') {
      return 'login.errors.account_disabled'.tr();
    }

    if (cleanError == 'AUTH.ACCOUNT_NOT_VERIFIED' ||
        cleanError == 'Please verify your email address first' ||
        cleanError == 'User not verified') {
      return 'login.errors.account_not_verified'.tr();
    }

    if (cleanError == 'AUTH.USER_NOT_FOUND' || cleanError == 'User not found') {
      return 'login.errors.user_not_found'.tr();
    }

    switch (cleanError) {
      case 'Failed to connect to the server':
        return 'login.errors.failed_connect_server'.tr();
      default:
        return 'login.errors.unexpected'.tr();
    }
  }

  /// Dispose
  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}
