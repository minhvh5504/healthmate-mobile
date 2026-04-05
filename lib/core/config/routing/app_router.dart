import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/pages/forgotpassword/reset_password_page.dart';
import '../../../features/auth/presentation/pages/forgotpassword/send_request_page.dart';
import '../../../features/auth/presentation/pages/forgotpassword/verify_password_page.dart';
import '../../../features/auth/presentation/pages/login/login_page.dart';
import '../../../features/auth/presentation/pages/register/register_page.dart';
import '../../../features/auth/presentation/pages/register/verify_account_page.dart';
import '../../../features/notifications/presentation/pages/notification_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../../features/onboarding/presentation/pages/splash_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/medicine/presentation/pages/medicine_page.dart';
import '../../../features/health/presentation/pages/health_page.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/settings/presentation/pages/profile_page.dart';
import '../../../features/settings/presentation/pages/notification_settings_page.dart';
import '../../../features/settings/presentation/pages/high_settings_page.dart';
import '../../../features/settings/presentation/pages/change_password_page.dart';
import '../../../features/auth/presentation/pages/register/register_intro_page.dart';
import '../../../features/settings/presentation/pages/family_connection_page.dart';
import '../../../features/settings/presentation/pages/add_family_member_page.dart';
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

      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.highSettings,
        builder: (context, state) => const HighSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.changepassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.familyConnection,
        builder: (context, state) => const FamilyConnectionPage(),
      ),
      GoRoute(
        path: AppRoutes.addFamilyMember,
        builder: (context, state) => const AddFamilyMemberPage(),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationPage(),
      ),

      // Shell Route
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getNavIndex(state.uri.path);
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
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
            path: AppRoutes.medicine,
            builder: (context, state) => const MedicinePage(),
          ),
          GoRoute(
            path: AppRoutes.health,
            builder: (context, state) => const HealthPage(),
          ),
          GoRoute(
            path: AppRoutes.history,
            builder: (context, state) => const HistoryPage(),
          ),
        ],
      ),
    ],
  );

  static int _getNavIndex(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    if (path.startsWith(AppRoutes.medicine)) return 1;
    if (path.startsWith(AppRoutes.health)) return 2;
    if (path.startsWith(AppRoutes.history)) return 3;
    return 0;
  }
}
