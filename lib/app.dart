import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toastification/toastification.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/utils/app_toast.dart';
import 'core/widgets/app_dot_loader.dart';
import 'features/auth/presentation/providers/login/login_provider.dart';
import 'features/auth/presentation/providers/register/register_provider.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isLoginLoading = ref.watch(
      loginNotifierProvider.select((state) => state.isLoading),
    );
    final isRegisterLoading = ref.watch(
      registerNotifierProvider.select((state) => state.isLoading),
    );
    final isAuthLoading = isLoginLoading || isRegisterLoading;

    ref.listen<int>(
      notificationProvider.select((state) => state.realtimeNotificationSerial),
      (previous, next) {
        if (previous == null || next <= previous) return;

        final notification = ref.read(
          notificationProvider.select(
            (state) => state.latestRealtimeNotification,
          ),
        );
        if (notification == null) return;

        final currentPath = router.routeInformationProvider.value.uri.path;
        if (currentPath == AppRoutes.notifications) return;

        AppToast.notification(
          title: notification.title.isNotEmpty
              ? notification.title
              : 'notifications.title'.tr(),
          message: notification.body,
        );
      },
    );

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            title: 'HealthMate',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
            routerConfig: router,
            builder: (context, child) => AppDotLoadingOverlay(
              isLoading: isAuthLoading,
              child: child ?? const SizedBox.shrink(),
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        );
      },
    );
  }
}
