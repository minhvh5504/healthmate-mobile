import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';

/// State
class OnboardingState {
  final int currentIndex;
  final bool isAutoScrolling;

  const OnboardingState({this.currentIndex = 0, this.isAutoScrolling = false});

  OnboardingState copyWith({int? currentIndex, bool? isAutoScrolling}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isAutoScrolling: isAutoScrolling ?? this.isAutoScrolling,
    );
  }
}

/// Notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  late final PageController controller;

  OnboardingNotifier() : super(const OnboardingState()) {
    controller = PageController();
  }

  /// Updates the current page index
  void onPageChanged(int index, int itemCount) {
    state = state.copyWith(currentIndex: index);
  }

  /// Handles user interaction events
  void onUserInteraction([int itemCount = 3]) {}

  /// Moves to the next page or navigates away
  void nextPage(BuildContext context, int itemCount) {
    if (state.currentIndex < itemCount - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      context.go(AppRoutes.registerintro);
    }
  }

  /// Handles login button
  void handleLogin(BuildContext context) {
    // context.go(AppRoutes.login);
  }

  /// Disposes the page controller
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
