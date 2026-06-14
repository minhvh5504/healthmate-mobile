import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation {
  static LottieBuilder welcome({
    AnimationController? controller,
    void Function(LottieComposition)? onLoaded,
  }) => Lottie.asset(
    'assets/lottie/welcome.json',
    controller: controller,
    onLoaded: onLoaded,
  );

  static LottieBuilder get premiumPls =>
      Lottie.asset('assets/lottie/premium_pls.json', height: 120, width: 120);

  static LottieBuilder get empty =>
      Lottie.asset('assets/lottie/empty.json', height: 100, width: 100);

  static LottieBuilder pomodoro1({double? size}) =>
      Lottie.asset('assets/lottie/pomodoro_1.json', height: size ?? 200);

  static LottieBuilder pomodoro2({double? size}) =>
      Lottie.asset('assets/lottie/pomodoro_2.json', height: size ?? 200);

  static LottieBuilder get cheering =>
      Lottie.asset('assets/lottie/cheering.json', height: 160);

  static LottieBuilder success({double? size}) => Lottie.asset(
    'assets/lottie/success.json',
    height: size ?? 400,
    width: size ?? 400,
  );

  static LottieBuilder get addFile =>
      Lottie.asset('assets/lottie/add_file.json', height: 120);

  static LottieBuilder get loveApp =>
      Lottie.asset('assets/lottie/love_app.json', height: 100);

  static LottieBuilder get rating =>
      Lottie.asset('assets/lottie/rating.json', height: 80, width: 160);
}
