import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/settings/domain/usecases/get_user_profile.dart';
import 'package:healthmate_mobile/features/settings/presentation/providers/settings/settings_provider.dart';
import 'high_settings_notifier.dart';

/// UseCases
final getUserProfileUseCaseProvider = Provider<GetUserProfile>((ref) {
  return GetUserProfile(ref.read(settingsRepositoryProvider));
});

final highSettingsProvider =
    StateNotifierProvider<HighSettingsNotifier, HighSettingsState>((ref) {
      return HighSettingsNotifier(ref);
    });
