// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/lottie_animation.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/splash/splash_notifier.dart';
import '../providers/splash/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final SplashNotifier _splashNotifier;
  @override
  void initState() {
    super.initState();
    _splashNotifier = ref.read(splashNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _splashNotifier.init(context, this);
    });
  }

  @override
  void dispose() {
    _splashNotifier.disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashNotifierProvider);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final animationWidth = isLandscape ? 170.w : 280.w;
    final headerHeight = isLandscape ? 20.h : 60.h;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: headerHeight),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: animationWidth,
                      child: LottieAnimation.welcome(
                        controller: state.controller,
                      ),
                    ),
                    Text(
                      appName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isLandscape ? 24.sp : 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.typoHeading,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
