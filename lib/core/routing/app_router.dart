import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/forgotpassword/reset_password_page.dart';
import '../../features/auth/presentation/pages/forgotpassword/send_request_page.dart';
import '../../features/auth/presentation/pages/forgotpassword/verify_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/auth/presentation/pages/register/verify_account_page.dart';
import '../../features/medicine/domain/entities/user_medication.dart';
import '../../features/medicine/presentation/pages/add_medicine/add_medicine_page.dart';
import '../../features/medicine/presentation/pages/medicine/medicine_page.dart';
import '../../features/medicine/presentation/pages/scan/scan_page.dart';
import '../../features/medicine/presentation/pages/scan/widgets/scan_medicine_box_page.dart';
import '../../features/medicine/presentation/pages/scan/widgets/scan_prescription_page.dart';
import '../../features/medicine/presentation/pages/medicine_review/medicine_review_page.dart';
import '../../features/notifications/presentation/pages/notification_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';

import '../../features/health/presentation/pages/health/health_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/settings/presentation/pages/settings/settings_page.dart';
import '../../features/chat/presentation/pages/chat/chat_page.dart';
import '../../features/settings/presentation/pages/profile/profile_page.dart';
import '../../features/settings/presentation/pages/notification_settings/notification_settings_page.dart';
import '../../features/settings/presentation/pages/high_settings/high_settings_page.dart';
import '../../features/settings/presentation/pages/change_password/change_password_page.dart';
import '../../features/auth/presentation/pages/register/register_intro_page.dart';
import '../../features/settings/presentation/pages/family_connection/family_connection_page.dart';
import '../../features/settings/presentation/pages/add_family_member/add_family_member_page.dart';

import '../../features/medicine/presentation/pages/medicine_options/medicine_options_page.dart';
import '../../features/medicine/presentation/pages/medicine_detail_preview/medicine_detail_preview_page.dart';
import '../../features/medicine/presentation/pages/medicine_reminder/medicine_reminder_page.dart';
import '../../features/medicine/presentation/pages/medicine_stock/medicine_stock_page.dart';
import '../../features/medicine/presentation/pages/medicine_detail_preview_edit/medicine_detail_preview_edit_page.dart';
import '../../features/medicine/presentation/pages/medicine_reminder_edit/medicine_reminder_edit_page.dart';
import '../../features/medicine/presentation/pages/medicine_stock_edit/medicine_stock_edit_page.dart';
import '../widgets/chat/floating_chat_button.dart';
import '../widgets/navigation/custom_bottom_navigation.dart';
import '../handlers/deeplink_handler.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) => DeepLinkHandler.handleRedirect(ref, state),
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
        path: AppRoutes.familyAccept,
        builder: (context, state) => const FamilyConnectionPage(),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationPage(),
      ),

      GoRoute(
        path: AppRoutes.addMedicine,
        builder: (context, state) => const AddMedicinePage(),
      ),
      GoRoute(
        path: AppRoutes.scanPrescription,
        builder: (context, state) {
          final fromTaskId = state.extra as String?;
          return ScanPrescriptionPage(fromTaskId: fromTaskId);
        },
      ),
      GoRoute(
        path: AppRoutes.scanMedicineBox,
        builder: (context, state) {
          final fromTaskId = state.extra as String?;
          return ScanMedicineBoxPage(fromTaskId: fromTaskId);
        },
      ),
      GoRoute(
        path: AppRoutes.reviewScan,
        builder: (context, state) {
          final taskId = state.extra as String;
          return ScanPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: AppRoutes.medicineReview,
        builder: (context, state) {
          final taskId = state.extra as String?;
          return MedicineReviewPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: AppRoutes.medicineDetailPreview,
        builder: (context, state) => const MedicineDetailPreviewPage(),
      ),
      GoRoute(
        path: AppRoutes.medicineOptions,
        builder: (context, state) {
          final medication = state.extra as UserMedication?;
          return MedicineOptionsPage(medication: medication);
        },
      ),
      GoRoute(
        path: AppRoutes.medicineReminder,
        builder: (context, state) => const MedicineReminderPage(),
      ),
      GoRoute(
        path: AppRoutes.medicineStock,
        builder: (context, state) => const MedicineStockPage(),
      ),
      GoRoute(
        path: AppRoutes.medicineDetailPreviewEdit,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MedicineDetailPreviewEditPage(medication: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.medicineReminderEdit,
        builder: (context, state) {
          final medication = state.extra as Map<String, dynamic>? ?? {};
          return MedicineReminderEditPage(medication: medication);
        },
      ),
      GoRoute(
        path: AppRoutes.medicineStockEdit,
        builder: (context, state) {
          final medication = state.extra as Map<String, dynamic>? ?? {};
          return MedicineStockEditPage(medication: medication);
        },
      ),

      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ChatPage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getNavIndex(state.uri.path);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                child,
                const Positioned.fill(child: FloatingChatButton()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNavBar(initialIndex: currentIndex),
                ),
              ],
            ),
          );
        },
        routes: [
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
  AppRouter.router = router;
  return router;
});

int _getNavIndex(String path) {
  if (path.startsWith(AppRoutes.medicine)) return 0;
  if (path.startsWith(AppRoutes.health)) return 1;
  if (path.startsWith(AppRoutes.history)) return 2;
  return 0;
}

class AppRouter {
  static late GoRouter router;
}
