import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthmate_mobile/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: const [Locale('vi'), Locale('en')],
          path: 'assets/lang',
          fallbackLocale: const Locale('vi'),
          child: const MyApp(),
        ),
      ),
    );

    // Verify that our app starts.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
