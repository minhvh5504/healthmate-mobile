import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmate_mobile/core/providers/socket_realtime_provider.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'core/services/push_notification_service.dart';
import 'core/handlers/notification_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  GoogleFonts.config.allowRuntimeFetching = false;

  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();

  // Initialize Push Notifications
  await PushNotificationService.initialize(
    onTokenRefresh: (token) async {
      await container.read(deviceTokenServiceProvider).registerToken(token);
    },
    onForegroundMessage: (message) {
      debugPrint('Received foreground message: ${message.messageId}');
    },
    onMessageOpenedApp: NotificationHandler.handleNotificationTap,
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        path: 'assets/lang',
        fallbackLocale: const Locale('vi'),
        child: const MyApp(),
      ),
    ),
  );
}
