import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'core/services/push_notification_service.dart';
import 'core/handlers/notification_handler.dart';

import 'core/providers/app_reset_provider.dart';
import 'core/providers/socket_realtime_provider.dart';
import 'features/auth/presentation/providers/auth/auth_provider.dart';

class AppInitializer extends ConsumerStatefulWidget {
  final Widget child;
  const AppInitializer({super.key, required this.child});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await PushNotificationService.initialize(
      onTokenRefresh: (token) async {
        final accessToken = ref.read(authProvider).accessToken;
        if (accessToken == null || accessToken.isEmpty) return;

        await ref
            .read(deviceTokenServiceProvider)
            .registerToken(token, accessToken: accessToken);
      },
      onForegroundMessage: (message) {
        debugPrint('Received foreground message: ${message.messageId}');
      },
      onMessageOpenedApp: NotificationHandler.handleNotificationTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  GoogleFonts.config.allowRuntimeFetching = false;

  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ListenableBuilder(
      listenable: AppResetProvider(),
      builder: (context, child) {
        return ProviderScope(
          key: UniqueKey(),
          child: EasyLocalization(
            supportedLocales: const [Locale('vi'), Locale('en')],
            path: 'assets/lang',
            fallbackLocale: const Locale('vi'),
            child: const AppInitializer(child: MyApp()),
          ),
        );
      },
    ),
  );
}
