// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation.dart';

import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify_password.dart';
import 'send_request_provider.dart';

const _undefined = Object();

class VerifyPasswordState {
  final String otpCode;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isResending;
  final String? errorMessage;
  final int remainingSeconds;
  final int resendSeconds;
  final String email;
  final String resetToken;

  const VerifyPasswordState({
    this.otpCode = '',
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isResending = false,
    this.errorMessage,
    this.remainingSeconds = 5,
    this.resendSeconds = 300,
    this.email = '',
    this.resetToken = '',
  });

  VerifyPasswordState copyWith({
    String? otpCode,
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isResending,
    Object? errorMessage = _undefined,
    int? remainingSeconds,
    int? resendSeconds,
    String? email,
    String? resetToken,
  }) {
    return VerifyPasswordState(
      otpCode: otpCode ?? this.otpCode,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isResending: isResending ?? this.isResending,
      errorMessage: identical(errorMessage, _undefined)
          ? this.errorMessage
          : errorMessage as String?,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      email: email ?? this.email,
      resetToken: resetToken ?? this.resetToken,
    );
  }
}

class VerifyPasswordNotifier extends StateNotifier<VerifyPasswordState> {
  final VerifyPasswordS _verifyCodeUseCase;
  final ResendCode _resendCodeUseCase;
  final Ref _ref;
  Timer? _timer;

  VerifyPasswordNotifier(
    this._verifyCodeUseCase,
    this._resendCodeUseCase,
    this._ref,
  ) : super(const VerifyPasswordState()) {
    _startTimer();
    _initEmail();
  }

  void _initEmail() {
    final email = _ref
        .read(sendRequestNotifierProvider)
        .emailController
        .text
        .trim();
    state = state.copyWith(email: email);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start countdown timer
  void _startTimer({bool resetResend = false}) {
    if (resetResend) {
      state = state.copyWith(resendSeconds: 300);
    }

    if (_timer?.isActive ?? false) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remaining = state.remainingSeconds;
      int resend = state.resendSeconds;

      if (remaining > 0) remaining--;
      if (resend > 0) resend--;

      final shouldClearError = remaining == 0 && state.errorMessage != null;

      state = state.copyWith(
        remainingSeconds: remaining,
        resendSeconds: resend,
        errorMessage: shouldClearError ? null : state.errorMessage,
      );

      if (remaining == 0 && resend == 0) {
        timer.cancel();
      }
    });
  }

  void _resetErrorTimer() {
    state = state.copyWith(remainingSeconds: 5);
    _startTimer();
  }

  // Called when user completes input code
  void onCodeCompleted(String code) {
    final valid = Validation.isCodeActive(code);
    state = state.copyWith(otpCode: code, isValid: valid);
  }

  void onCodeChanged(String code) {
    final valid = Validation.isCodeActive(code);
    state = state.copyWith(otpCode: code, isValid: valid, errorMessage: null);
  }

  void clearCode() {
    state = state.copyWith(otpCode: '', isValid: false);
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  // Format remaining seconds to MM:SS
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // Verify code when pressing "Verify"
  Future<void> onVerify(BuildContext context) async {
    if (!state.isValid) return;

    try {
      _setLoading(true);

      final email = state.email;

      final response = await _verifyCodeUseCase(email, state.otpCode, 'forgotpassword');

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        resetToken: response.resetToken,
      );

      context.go(AppRoutes.resetpassword);
    } catch (e) {
      _resetErrorTimer();
      _handleFailure(context, e);
    }
  }

  // Handle resend code
  Future<void> onResend(BuildContext context) async {
    try {
      try {
        FocusScope.of(context).unfocus();
      } catch (_) {}

      state = state.copyWith(
        isResending: true,
        errorMessage: null,
        otpCode: '',
        isValid: false,
      );

      final email = state.email;

      await _resendCodeUseCase(email, 'forgotpassword');

      state = state.copyWith(isResending: false);
      _startTimer(resetResend: true);
    } catch (e) {
      state = state.copyWith(isResending: false);
      _handleFailure(context, e);
    }
  }

  // Handle failure
  void _handleFailure(BuildContext context, Object error) {
    String? messageCode;
    String fallbackMessage = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        messageCode = (data['messageCode'] ?? data['errorCode'])?.toString();
        fallbackMessage = data['message']?.toString() ?? fallbackMessage;
      } else {
        fallbackMessage = error.message ?? fallbackMessage;
      }
    } else {
      fallbackMessage = error.toString();
    }

    final message = _translateError(messageCode ?? fallbackMessage);

    state = state.copyWith(isLoading: false, errorMessage: message);
  }

  // Update loading state
  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value, errorMessage: null);
  }

  // Translate errors from use case or API
  String _translateError(String errorCode) {
    final error = errorCode.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'AUTH.VERIFY.USER_NOT_FOUND':
        return 'verify_password.errors.invalid_phone_or_email'.tr();
      case 'AUTH.VERIFY.INVALID_OTP':
      case 'HTTP.400':
      case '400':
        return 'verify_password.errors.invalid_code'.tr();
      case 'AUTH.VERIFY.OTP_EXPIRED':
        return 'verify_password.errors.expired_code'.tr();
      case 'AUTH.VERIFY.ALREADY_VERIFIED':
        return 'verify_password.errors.already_verified'.tr();
      case 'AUTH.LOGIN.ACCOUNT_DISABLED':
        return 'verify_password.errors.account_disabled'.tr();
      case 'AUTH.LOGIN.NOT_VERIFIED':
        return 'verify_password.errors.account_not_verified'.tr();
      default:
        return 'verify_password.errors.unexpected'.tr();
    }
  }

  // Navigate back to SendRequest page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.sendrequest);
  }
}
