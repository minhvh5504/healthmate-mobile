// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../domain/usecases/change_password.dart';

class ChangePasswordState {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  final bool hasCurrentPasswordError;
  final bool hasNewPasswordError;
  final bool hasConfirmPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const ChangePasswordState({
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.hasCurrentPasswordError = false,
    this.hasNewPasswordError = false,
    this.hasConfirmPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ChangePasswordState copyWith({
    bool? hasCurrentPasswordError,
    bool? hasNewPasswordError,
    bool? hasConfirmPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChangePasswordState(
      currentPasswordController: currentPasswordController,
      newPasswordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      hasCurrentPasswordError:
          hasCurrentPasswordError ?? this.hasCurrentPasswordError,
      hasNewPasswordError: hasNewPasswordError ?? this.hasNewPasswordError,
      hasConfirmPasswordError:
          hasConfirmPasswordError ?? this.hasConfirmPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePassword _changePasswordUseCase;

  ChangePasswordNotifier(this._changePasswordUseCase)
    : super(
        ChangePasswordState(
          currentPasswordController: TextEditingController(),
          newPasswordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _addListeners();
  }

  /// Add listeners
  void _addListeners() {
    state.currentPasswordController.addListener(_validateAll);
    state.newPasswordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  /// Validate all
  void _validateAll() {
    final currentPassword = state.currentPasswordController.text;
    final newPassword = state.newPasswordController.text;
    final confirmPassword = state.confirmPasswordController.text;

    final currentError = currentPasswordErrorText;
    final currentValid = currentPassword.isNotEmpty && currentError == null;

    final newValid = Validation.isStrongPassword(newPassword);
    final confirmValid =
        confirmPassword == newPassword && confirmPassword.isNotEmpty;

    final isValid = currentValid && newValid && confirmValid;

    state = state.copyWith(
      hasCurrentPasswordError:
          currentError != null && currentPassword.isNotEmpty,
      hasNewPasswordError: !newValid && newPassword.isNotEmpty,
      hasConfirmPasswordError: !confirmValid && confirmPassword.isNotEmpty,
      isValid: isValid,
    );
  }

  /// Current password error text
  String? get currentPasswordErrorText {
    final text = state.currentPasswordController.text;
    if (text.isEmpty) return null;
    if (text.length < 8) return 'register.error_password_min_length'.tr();
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

  /// New password error text
  String? get newPasswordErrorText {
    final text = state.newPasswordController.text;
    if (text.isEmpty) return null;
    if (text.length < 8) return 'register.error_password_min_length'.tr();
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

  /// Confirm password error text
  String? get confirmPasswordErrorText {
    final text = state.confirmPasswordController.text;
    if (text.isEmpty) return null;
    if (text != state.newPasswordController.text) {
      return 'register.error_password_match'.tr();
    }
    return null;
  }

  /// Change password
  Future<void> onChangePassword(BuildContext context) async {
    if (state.isLoading || !state.isValid) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _changePasswordUseCase(
        state.currentPasswordController.text,
        state.newPasswordController.text,
      );

      AppRouter.router.go(AppRoutes.home);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _handleFailure(context, e);
    }
  }

  /// Handle failure
  void _handleFailure(BuildContext context, Object error) {
    String errorMessage = 'change_password.errors.unexpected'.tr();
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

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(message: message, onTap: () {}),
    );
  }

  /// Translate error messages
  String _translateError(String error) {
    final cleanError = error.replaceFirst('Exception: ', '').trim();

    switch (cleanError) {
      case 'AUTH.CHANGE_PASSWORD.WRONG_CURRENT_PASSWORD':
        return 'change_password.errors.wrong_current_password'.tr();
      case 'AUTH.PASSWORD.SAME_PASSWORD':
        return 'change_password.errors.same_password'.tr();
      case 'AUTH.CHANGE_PASSWORD.CONFIRM_MISMATCH':
        return 'change_password.errors.confirm_mismatch'.tr();
      case 'USER.NOT_FOUND':
        return 'change_password.errors.user_not_found'.tr();
      case 'AUTH.CHANGE_PASSWORD.OAUTH_NO_PASSWORD':
        return 'change_password.errors.oauth_no_password'.tr();
      default:
        return 'change_password.errors.unexpected'.tr();
    }
  }

  /// Navigate back
  void onBack() {
    AppRouter.router.go(AppRoutes.highSettings);
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  @override
  void dispose() {
    state.currentPasswordController.dispose();
    state.newPasswordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
