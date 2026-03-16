import 'package:flutter/material.dart';

class AppColors {
  // Color background
  static const Color bgPrimary = Color(0xFF007BFF);
  static const Color bgSecondary = Color(0xBF007BFF);
  static const Color bgBlur = Color(0xFF9FA19E);
  static const Color bgDisable = Color(0x809FA19E);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgHover = Color(0xFFF1F5F9);
  static const Color bgSuccess = Color(0xFF00BFA6);
  static const Color bgError = Color(0xFFE53935);
  static const Color bgWarning = Color(0xFFFCB044);

  // Color typrography
  static const Color typoPrimary = Color(0xFF007BFF);
  static const Color typoHeading = Color(0xFF434B94);
  static const Color typoBody = Color(0xFF475569);
  static const Color typoWhite = Color(0xFFFFFFFF);
  static const Color typoBlack = Color(0xFF0F1729);
  static const Color typoDisable = Color(0xFF94A3B8);
  static const Color typoError = Color(0xFFE53935);

  // New Design Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBlue = Color(0xFFDDE0F7);

  // Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, lightBlue],
  );
}
