import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'high_settings_notifier.dart';

final highSettingsProvider =
    StateNotifierProvider<HighSettingsNotifier, HighSettingsState>((ref) {
  return HighSettingsNotifier(ref);
});
