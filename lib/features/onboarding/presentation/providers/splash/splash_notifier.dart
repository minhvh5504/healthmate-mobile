// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/providers/app_state_provider.dart';

/// STATE
class SplashState {
  final AnimationController? controller;
  final Animation<double>? scaleAnim;
  final Animation<double>? fadeAnim;
  final bool hasNavigated;

  const SplashState({
    this.controller,
    this.scaleAnim,
    this.fadeAnim,
    this.hasNavigated = false,
  });

  SplashState copyWith({
    AnimationController? controller,
    Animation<double>? scaleAnim,
    Animation<double>? fadeAnim,
    bool? hasNavigated,
  }) {
    return SplashState(
      controller: controller ?? this.controller,
      scaleAnim: scaleAnim ?? this.scaleAnim,
      fadeAnim: fadeAnim ?? this.fadeAnim,
      hasNavigated: hasNavigated ?? this.hasNavigated,
    );
  }
}

/// NOTIFIER
class SplashNotifier extends StateNotifier<SplashState> {
  final Ref ref;
  bool _animationDisposed = false;
  SplashNotifier(this.ref) : super(const SplashState());

  /// Initialize when screen opens
  Future<void> init(BuildContext context, TickerProvider vsync) async {
    _animationDisposed = false;
    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1800),
    );

    final scaleAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    final fadeAnim = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    state = state.copyWith(
      controller: controller,
      scaleAnim: scaleAnim,
      fadeAnim: fadeAnim,
    );

    try {
      await controller.forward();
    } on TickerCanceled {
      return;
    }

    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted || !context.mounted) return;

    if (!state.hasNavigated) {
      state = state.copyWith(hasNavigated: true);

      // Check login status
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      final isLoggedIn = prefs.getBool('isLogin') ?? false;

      if (isLoggedIn) {
        context.go(AppRoutes.medicine);
      } else {
        context.go(AppRoutes.onboarding);
      }

      // Mark app as initialized for deep link handling
      ref.read(appInitializedProvider.notifier).state = true;
    }
  }

  void disposeAnimation() {
    final controller = state.controller;
    if (controller == null || _animationDisposed) return;

    _animationDisposed = true;
    controller.dispose();
  }

  /// Dispose
  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }
}
