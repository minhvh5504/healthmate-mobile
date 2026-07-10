import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_health_history.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_health_history_changes.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_notifier.dart';

export 'health_history_notifier.dart';

/// UseCase get health history
final getHealthHistoryUseCaseProvider = Provider<GetHealthHistory>((ref) {
  return GetHealthHistory(ref.read(healthRepositoryProvider));
});

/// UseCase get health history changes
final getHealthHistoryChangesUseCaseProvider =
    Provider<GetHealthHistoryChanges>((ref) {
      return GetHealthHistoryChanges(ref.read(healthRepositoryProvider));
    });

final healthHistoryProvider =
    StateNotifierProvider<HealthHistoryNotifier, HealthHistoryState>((ref) {
      return HealthHistoryNotifier(
        ref,
        ref.read(getUserProfileUseCaseProvider),
        ref.read(updateUserProfileUseCaseProvider),
        ref.read(getHealthHistoryUseCaseProvider),
        ref.read(getHealthHistoryChangesUseCaseProvider),
        () async {
          if (ref.exists(healthProvider)) {
            await ref.read(healthProvider.notifier).fetchProfile();
          }
        },
      );
    });
