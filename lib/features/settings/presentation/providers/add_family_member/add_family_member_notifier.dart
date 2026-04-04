import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation.dart';

/// STATE
class AddFamilyMemberState {
  final bool isLoading;
  final TextEditingController emailController;
  final String? errorMessage;
  final bool isSuccess;
  final bool emailValid;
  final bool hasEmailError;
  final bool isValid;

  AddFamilyMemberState({
    this.isLoading = false,
    required this.emailController,
    this.errorMessage,
    this.isSuccess = false,
    this.emailValid = false,
    this.hasEmailError = false,
    this.isValid = false,
  });

  AddFamilyMemberState copyWith({
    bool? isLoading,
    TextEditingController? emailController,
    String? errorMessage,
    bool? isSuccess,
    bool? emailValid,
    bool? hasEmailError,
    bool? isValid,
  }) {
    return AddFamilyMemberState(
      isLoading: isLoading ?? this.isLoading,
      emailController: emailController ?? this.emailController,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      emailValid: emailValid ?? this.emailValid,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// NOTIFIER
class AddFamilyMemberNotifier extends StateNotifier<AddFamilyMemberState> {
  final Ref ref;

  AddFamilyMemberNotifier(this.ref)
    : super(AddFamilyMemberState(emailController: TextEditingController())) {
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

  @override
  void dispose() {
    state.emailController.dispose();
    super.dispose();
  }

  /// Handle Connect
  Future<void> onConnect() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(isLoading: false, isSuccess: true);
      // AppRouter.router.pop();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.familyConnection);
  }
}
