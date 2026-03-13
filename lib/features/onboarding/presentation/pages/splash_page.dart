// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/splash/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashNotifierProvider.notifier).init(context, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      extendBody: true,

      body: Center(
        child: FadeTransition(
          opacity: state.fadeAnim ?? kAlwaysCompleteAnimation,
          child: ScaleTransition(
            scale: state.scaleAnim ?? kAlwaysCompleteAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/app/logo.svg',
                  height: 60.h,
                  width: 60.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
