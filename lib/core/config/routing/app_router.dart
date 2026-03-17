import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/pages/forgotpassword/reset_password_page.dart';
import '../../../features/auth/presentation/pages/forgotpassword/send_request_page.dart';
import '../../../features/auth/presentation/pages/forgotpassword/verify_password_page.dart';
import '../../../features/auth/presentation/pages/login/login_page.dart';
import '../../../features/auth/presentation/pages/register/register_page.dart';
import '../../../features/auth/presentation/pages/register/verify_account_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../features/onboarding/presentation/pages/splash_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/auth/presentation/pages/register/register_intro_page.dart';
import '../../widgets/navigation/custom_bottom_navigation.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.registerintro,
        builder: (context, state) => const RegisterIntroPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.verifyaccount,
        builder: (context, state) => const VerifyAccountPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.sendrequest,
        builder: (context, state) => const SendRequestPage(),
      ),
      GoRoute(
        path: AppRoutes.verifypassword,
        builder: (context, state) => const VerifyPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetpassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),

      // Shell Route
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getNavIndex(state.uri.path);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavBar(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );

  static int _getNavIndex(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    if (path.startsWith(AppRoutes.profile)) return 1;
    if (path.startsWith(AppRoutes.settings)) return 2;
    return 0;
  }
}
