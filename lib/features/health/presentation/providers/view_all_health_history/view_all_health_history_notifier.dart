import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';

class ViewAllHealthHistoryState {
  final List<HealthHistoryEntry> entries;
  final bool isLoading;
  final String? errorMessage;

  const ViewAllHealthHistoryState({
    this.entries = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ViewAllHealthHistoryState copyWith({
    List<HealthHistoryEntry>? entries,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ViewAllHealthHistoryState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}

class ViewAllHealthHistoryNotifier
    extends StateNotifier<ViewAllHealthHistoryState> {
  ViewAllHealthHistoryNotifier(this._ref)
    : super(const ViewAllHealthHistoryState()) {
    _syncFromHealthHistoryState(_ref.read(healthHistoryProvider));
    _ref.listen<HealthHistoryState>(healthHistoryProvider, (previous, next) {
      _syncFromHealthHistoryState(next);
    });
  }

  final Ref _ref;

  void _syncFromHealthHistoryState(HealthHistoryState historyState) {
    state = ViewAllHealthHistoryState(
      entries: historyState.historyChanges == null
          ? const []
          : historyState.allEntries,
      isLoading: historyState.isLoading,
      errorMessage: historyState.isLoading ? null : state.errorMessage,
    );
  }

  Future<void> fetchHealthHistory({HealthHistoryMetric? metric}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _ref
          .read(healthHistoryProvider.notifier)
          .fetchHealthHistoryChanges(metric: metric);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
      AppToast.error(e);
    }
  }
}
