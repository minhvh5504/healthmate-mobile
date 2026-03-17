// Represents the state of the Send Request screen
// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../domain/usecases/send_request.dart';

class SendRequestState {
  final TextEditingController emailController;
  final bool emailValid;
  final bool hasEmailError;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SendRequestState({
    required this.emailController,
    this.emailValid = false,
    this.hasEmailError = false,
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SendRequestState copyWith({
    bool? emailValid,
    bool? hasEmailError,
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SendRequestState(
      emailController: emailController,
      emailValid: emailValid ?? this.emailValid,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class SendRequestNotifier extends StateNotifier<SendRequestState> {
  final SendRequest _sendRequestUseCase;
  final Ref ref;

  SendRequestNotifier(this._sendRequestUseCase, this.ref)
    : super(SendRequestState(emailController: TextEditingController())) {
    _initListeners();
  }

  // Listen to input changes and validate
  void _initListeners() {
    state.emailController.addListener(_validateInput);
  }

  // Validate email input
  void _validateInput() {
    final text = state.emailController.text.trim();
    final valid = Validation.isValidEmail(text);

    final hasEmailError = !valid && text.isNotEmpty;

    state = state.copyWith(
      emailValid: valid,
      hasEmailError: hasEmailError,
      isValid: valid,
    );
  }

  // Trigger when user presses "Send Code"
  Future<void> onSendCode(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;
    final input = state.emailController.text.trim();

    try {
      _setLoading(true);
      await _sendRequestUseCase(input);
      await _handleSuccess(context);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  /// Get error text
  String? get emailErrorText {
    final text = state.emailController.text.trim();

    if (text.isEmpty) return null;

    if (!Validation.isValidEmail(text)) {
      return 'forgot_password.error_invalid_email'.tr();
    }

    return null;
  }

  // Handle success
  Future<void> _handleSuccess(BuildContext context) async {
    _setLoading(false);
    state = state.copyWith(isSuccess: true);

    context.go(AppRoutes.verifypassword);
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

  // Update loading state
  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value, errorMessage: null);
  }

  // Translate error messages
  String _translateError(String error) {
    final cleanError = error.replaceFirst('Exception: ', '').trim();

    if (cleanError == 'USER.NOT_FOUND' ||
        cleanError == 'User with this email does not exist!') {
      return 'forgot_password.errors.user_not_found'.tr();
    }

    switch (cleanError) {
      case 'Failed to connect to the server':
        return 'forgot_password.errors.failed_connect_server'.tr();
      default:
        return 'forgot_password.errors.unexpected'.tr();
    }
  }

  // Navigate to Login page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // Dispose controller when not needed
  @override
  void dispose() {
    state.emailController.dispose();
    super.dispose();
  }
}
