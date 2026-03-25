import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../auth/presentation/providers/login/login_provider.dart';
import '../../widgets/login_modal.dart';

/// State
class OnboardingState {
  final int currentIndex;
  final bool isLoading;

  const OnboardingState({this.currentIndex = 0, this.isLoading = false});

  OnboardingState copyWith({int? currentIndex, bool? isLoading}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  late final PageController controller;
  final Ref ref;

  OnboardingNotifier(this.ref) : super(const OnboardingState()) {
    controller = PageController();
  }

  /// Updates the current page index
  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }

  /// Handle next page
  void nextPage(BuildContext context) {
    context.go(AppRoutes.registerintro);
  }

  /// Handles login button
  void handleLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoginModal(
        onContinueWithEmail: () => onContinueWithEmail(context),
        onContinueWithGoogle: () =>
            ref.read(loginNotifierProvider.notifier).onContinueWithGoogle(context),
      ),
    );
  }

  /// Handle Continue with Email
  void onContinueWithEmail(BuildContext context) {
    context.pop();
    context.push(AppRoutes.login);
  }

  /// Disposes the page controller
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
