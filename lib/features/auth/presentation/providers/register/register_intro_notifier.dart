// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';

/// STATE
class RegisterIntroState {
  final bool isLoading;

  const RegisterIntroState({this.isLoading = false});

  RegisterIntroState copyWith({bool? isLoading}) {
    return RegisterIntroState(isLoading: isLoading ?? this.isLoading);
  }
}

/// NOTIFIER
class RegisterIntroNotifier extends StateNotifier<RegisterIntroState> {
  final Ref ref;

  RegisterIntroNotifier(this.ref) : super(const RegisterIntroState());

  /// Navigate back
  void onBack(BuildContext context) {
    context.go(AppRoutes.splash);
  }

  /// Navigate to Register page
  void onContinueWithEmail(BuildContext context) {
    context.go(AppRoutes.register);
  }
}
