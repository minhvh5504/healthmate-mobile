// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/previous_page_provider.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../domain/usecases/register_account.dart';

class RegisterState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool hasEmailError;
  final bool hasPasswordError;
  final bool hasConfirmPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.hasEmailError = false,
    this.hasPasswordError = false,
    this.hasConfirmPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? hasEmailError,
    bool? hasPasswordError,
    bool? hasConfirmPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      hasConfirmPasswordError:
          hasConfirmPasswordError ?? this.hasConfirmPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterAccount _registerUseCase;
  final Ref _ref;

  RegisterNotifier(this._registerUseCase, this._ref)
    : super(
        RegisterState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _addListeners();
  }

  // Add listeners
  void _addListeners() {
    state.emailController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate all input fields
  void _validateAll() {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();
    final confirmPassword = state.confirmPasswordController.text.trim();

    final emailValid = Validation.isValidEmail(email);
    final passwordValid = Validation.isStrongPassword(password);
    final confirmPasswordValid = confirmPassword == password;

    final isValid = emailValid && passwordValid && confirmPasswordValid;

    state = state.copyWith(
      hasEmailError: !emailValid && email.isNotEmpty,
      hasPasswordError: !passwordValid && password.isNotEmpty,
      hasConfirmPasswordError:
          !confirmPasswordValid && confirmPassword.isNotEmpty,
      isValid: isValid,
    );
  }

  /// Get error email text
  String? get emailErrorText {
    final text = state.emailController.text.trim();

    if (text.isEmpty) return null;

    if (!Validation.isValidEmail(text)) {
      return 'register.error_invalid_email'.tr();
    }

    return null;
  }

  /// Get error password text
  String? get passwordErrorText {
    final text = state.passwordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'register.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'register.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'register.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'register.error_password_special'.tr();
    }

    return null;
  }

  /// Get error confirm password text
  String? get confirmPasswordErrorText {
    final text = state.confirmPasswordController.text;

    if (text.isEmpty) return null;

    if (text != state.passwordController.text) {
      return 'register.error_password_match'.tr();
    }

    return null;
  }

  // Handle Sign Up action
  Future<void> onSignUp(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    _setLoading(true);

    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();

    try {
      await _registerUseCase(email, password);
      _setLoading(false);

      _ref.read(previousPageProvider.notifier).state = 'register';
      context.go(AppRoutes.verifyaccount);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  // Handle failure
  void _handleFailure(BuildContext context, Object error) {
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

    final message = _translateError(errorCode ?? errorMessage);
    state = state.copyWith(isLoading: false, errorMessage: message);

    final isEmailExists =
        errorCode == 'AUTH.REGISTER.EMAIL_EXISTS' ||
        errorMessage.contains('Email already registered') ||
        errorMessage.contains('Email already exists') ||
        errorCode == '409';

    if (isEmailExists) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ConfirmDialog(
          message: 'register.errors.email_exists'.tr(),
          onTap: () {},
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.typoError,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Translate error messages
  String _translateError(String error) {
    final cleanError = error.replaceFirst('Exception: ', '').trim();
    if (cleanError == 'AUTH.REGISTER.EMAIL_EXISTS' || cleanError == '409') {
      return 'register.errors.email_exists'.tr();
    }

    switch (cleanError) {
      case 'email must be an email':
        return 'register.errors.invalid_email'.tr();
      default:
        return 'register.errors.unexpected'.tr();
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Handle Back
  void onPressBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.registerintro);
    }
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
