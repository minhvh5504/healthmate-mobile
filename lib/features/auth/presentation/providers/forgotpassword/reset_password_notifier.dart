// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../domain/usecases/reset_password.dart';
import 'verify_password_provider.dart';

class ResetPasswordState {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool newPassValid;
  final bool confirmPassValid;
  final bool hasNewPassError;
  final bool hasConfirmPassError;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const ResetPasswordState({
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.newPassValid = false,
    this.confirmPassValid = false,
    this.hasNewPassError = false,
    this.hasConfirmPassError = false,
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? newPassValid,
    bool? confirmPassValid,
    bool? hasNewPassError,
    bool? hasConfirmPassError,
  }) {
    return ResetPasswordState(
      newPasswordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      newPassValid: newPassValid ?? this.newPassValid,
      confirmPassValid: confirmPassValid ?? this.confirmPassValid,
      hasNewPassError: hasNewPassError ?? this.hasNewPassError,
      hasConfirmPassError: hasConfirmPassError ?? this.hasConfirmPassError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPassword _resetPasswordUseCase;
  final Ref _ref;

  ResetPasswordNotifier(this._resetPasswordUseCase, this._ref)
    : super(
        ResetPasswordState(
          newPasswordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _initListeners();
  }

  // Listen to input changes
  void _initListeners() {
    state.newPasswordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate password and confirm password
  void _validateAll() {
    final newPass = state.newPasswordController.text.trim();
    final confirmPass = state.confirmPasswordController.text.trim();

    final passwordValid = Validation.isStrongPassword(newPass);
    final confirmPasswordValid = confirmPass == newPass;

    final isValid = passwordValid && confirmPasswordValid;

    state = state.copyWith(
      isValid: isValid,

      hasNewPassError: !passwordValid && newPass.isNotEmpty,
      hasConfirmPassError: !confirmPasswordValid && confirmPass.isNotEmpty,
    );
  }

  /// Get error password text
  String? get passwordErrorText {
    final text = state.newPasswordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'reset_password.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'reset_password.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'reset_password.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'reset_password.error_password_special'.tr();
    }

    return null;
  }

  /// Get error confirm password text
  String? get confirmPasswordErrorText {
    final text = state.confirmPasswordController.text;

    if (text.isEmpty) return null;

    if (text != state.newPasswordController.text) {
      return 'reset_password.error_password_match'.tr();
    }

    return null;
  }

  // Submit save new password
  Future<void> onSubmit(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    final resetToken = _ref.read(verifyPasswordNotifierProvider).resetToken;
    final newPassword = state.newPasswordController.text.trim();

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _resetPasswordUseCase(resetToken, newPassword);

      state = state.copyWith(isLoading: false, isSuccess: true);

      context.go(AppRoutes.login);
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(message: message, onTap: () {}),
    );
  }

  // Translate error messages
  String _translateError(String error) {
    final cleanError = error.replaceFirst('Exception: ', '').trim();

    if (cleanError == 'AUTH.INVALID_TOKEN' ||
        cleanError == 'Invalid or expired reset token' ||
        cleanError == 'Invalid token type') {
      return 'reset_password.errors.invalid_token'.tr();
    }

    if (cleanError == 'AUTH.USER_NOT_FOUND' || 
        cleanError == 'User not found') {
      return 'reset_password.errors.user_not_found'.tr();
    }

    if (cleanError == 'AUTH.ACCOUNT_DISABLED' ||
        cleanError == 'Your account has been deactivated/blocked by admin') {
      return 'reset_password.errors.account_disabled'.tr();
    }

    if (cleanError == 'Invalid password') {
      return 'reset_password.errors.invalid_password'.tr();
    }

    if (cleanError == 'Invalid phone or email') {
      return 'reset_password.errors.invalid_phone_or_email'.tr();
    }

    switch (cleanError) {
      case 'Failed to connect to the server':
        return 'reset_password.errors.failed_connect_server'.tr();
      default:
        return 'reset_password.errors.unexpected'.tr();
    }
  }

  // Navigate back to VerifyPassword page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.verifypassword);
  }

  @override
  void dispose() {
    state.newPasswordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
