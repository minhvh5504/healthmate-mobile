import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/user_provider.dart';
import 'package:healthmate_mobile/core/routing/app_router.dart';
import 'package:healthmate_mobile/core/routing/app_routes.dart';
import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history_change.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_health_history.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_health_history_changes.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/get_user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/usecases/update_user_profile.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_info_bottom_sheet.dart';

enum HealthHistoryMetric { weight, height }

enum HealthHistoryRange { day, week, month }

class HealthHistoryEntry {
  final HealthHistoryMetric metric;
  final double value;
  final DateTime recordedAt;
  final double? change;
  final String direction;

  const HealthHistoryEntry({
    required this.metric,
    required this.value,
    required this.recordedAt,
    this.change,
    this.direction = 'initial',
  });

  Map<String, dynamic> toJson() {
    return {
      'metric': metric.name,
      'value': value,
      'recordedAt': recordedAt.toIso8601String(),
      'change': change,
      'direction': direction,
    };
  }

  factory HealthHistoryEntry.fromJson(Map<String, dynamic> json) {
    return HealthHistoryEntry(
      metric: HealthHistoryMetric.values.firstWhere(
        (metric) => metric.name == json['metric'],
        orElse: () => HealthHistoryMetric.weight,
      ),
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0,
      recordedAt:
          (DateTime.tryParse(json['recordedAt']?.toString() ?? '') ??
                  DateTime.now())
              .toLocal(),
      change: double.tryParse(json['change']?.toString() ?? ''),
      direction: json['direction']?.toString() ?? 'initial',
    );
  }
}

class HealthHistoryState {
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final List<HealthHistoryEntry> entries;
  final List<HealthHistoryEntry> allEntries;
  final HealthHistory? remoteHistory;
  final HealthHistoryChanges? historyChanges;
  final HealthHistoryMetric selectedMetric;
  final HealthHistoryRange selectedRange;
  final DateTime cursorDate;

  HealthHistoryState({
    this.isLoading = true,
    this.isSaving = false,
    this.errorMessage,
    this.entries = const [],
    this.allEntries = const [],
    this.remoteHistory,
    this.historyChanges,
    this.selectedMetric = HealthHistoryMetric.weight,
    this.selectedRange = HealthHistoryRange.day,
    DateTime? cursorDate,
  }) : cursorDate = cursorDate ?? DateTime.now();

  HealthHistoryState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    List<HealthHistoryEntry>? entries,
    List<HealthHistoryEntry>? allEntries,
    HealthHistory? remoteHistory,
    HealthHistoryChanges? historyChanges,
    HealthHistoryMetric? selectedMetric,
    HealthHistoryRange? selectedRange,
    DateTime? cursorDate,
  }) {
    return HealthHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      entries: entries ?? this.entries,
      allEntries: allEntries ?? this.allEntries,
      remoteHistory: remoteHistory ?? this.remoteHistory,
      historyChanges: historyChanges ?? this.historyChanges,
      selectedMetric: selectedMetric ?? this.selectedMetric,
      selectedRange: selectedRange ?? this.selectedRange,
      cursorDate: cursorDate ?? this.cursorDate,
    );
  }
}

class HealthHistoryNotifier extends StateNotifier<HealthHistoryState> {
  HealthHistoryNotifier(
    this.ref,
    this._getUserProfile,
    this._updateUserProfile,
    this._getHealthHistory,
    this._getHealthHistoryChanges,
  ) : super(HealthHistoryState()) {
    load();
  }

  final Ref ref;
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final GetHealthHistory _getHealthHistory;
  final GetHealthHistoryChanges _getHealthHistoryChanges;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final history = await _getHealthHistory(
        metric: _domainMetric(state.selectedMetric),
        period: _domainPeriod(state.selectedRange),
        date: state.cursorDate,
      );
      final changes = await _getHealthHistoryChanges(
        metric: _domainMetric(state.selectedMetric),
        period: _domainPeriod(state.selectedRange),
        date: state.cursorDate,
      );
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        entries: _entriesFromHistory(history),
        allEntries: _entriesFromChanges(changes),
        remoteHistory: history,
        historyChanges: changes,
        clearError: true,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
    }
  }

  Future<void> init({
    required HealthHistoryMetric metric,
    required double? currentValue,
  }) async {
    state = state.copyWith(
      selectedMetric: metric,
      selectedRange: HealthHistoryRange.week,
      cursorDate: DateTime.now(),
    );
    await load();
  }

  Future<void> changeRange(HealthHistoryRange range) async {
    state = state.copyWith(selectedRange: range, cursorDate: DateTime.now());
    await load();
  }

  Future<void> movePeriod(int direction) async {
    state = state.copyWith(cursorDate: _movedDate(direction));
    await load();
  }

  Future<void> fetchHealthHistory() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final history = await _getHealthHistory(
        metric: _domainMetric(state.selectedMetric),
        period: _domainPeriod(state.selectedRange),
        date: state.cursorDate,
      );
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        entries: _entriesFromHistory(history),
        remoteHistory: history,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
    }
  }

  Future<void> fetchHealthHistoryChanges({
    HealthHistoryMetric? metric,
    HealthHistoryRange? range,
    DateTime? date,
  }) async {
    final selectedMetric = metric ?? state.selectedMetric;
    final selectedRange = range ?? state.selectedRange;
    final cursorDate = date ?? state.cursorDate;

    state = state.copyWith(
      isLoading: true,
      selectedMetric: selectedMetric,
      selectedRange: selectedRange,
      cursorDate: cursorDate,
      clearError: true,
    );
    try {
      final changes = await _getHealthHistoryChanges(
        metric: _domainMetric(selectedMetric),
        period: _domainPeriod(selectedRange),
        date: cursorDate,
      );
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        allEntries: _entriesFromChanges(changes),
        historyChanges: changes,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppToast.message(e),
      );
    }
  }

  void openAllHistory() {
    AppRouter.router.push(
      AppRoutes.viewAllHealthHistory,
      extra: state.selectedMetric,
    );
  }

  void onShowWeightInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HealthInfoBottomSheet(
        title: 'health.weight_info_title'.tr(),
        content: 'health.weight_info_content'.tr(),
      ),
    );
  }

  void onShowHeightInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HealthInfoBottomSheet(
        title: 'health.height_info_title'.tr(),
        content: 'health.height_info_content'.tr(),
      ),
    );
  }

  Future<void> saveMetric({
    required BuildContext context,
    double? height,
    double? weight,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final currentProfile = await _getUserProfile();
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        email: currentProfile.email,
        heightCm: height,
        weightKg: weight,
      );

      await _updateUserProfile(updatedProfile);
      await ref.read(userProfileProvider.notifier).fetchProfile(force: true);
      await load();

      if (!mounted) return;
      state = state.copyWith(isSaving: false, clearError: true);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final message = AppToast.message(e);
      state = state.copyWith(isSaving: false, errorMessage: message);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> addEntry({
    required HealthHistoryMetric metric,
    required double value,
    DateTime? recordedAt,
  }) async {
    if (value <= 0) return;
    state = state.copyWith(selectedMetric: metric);
    await load();
  }

  List<HealthHistoryEntry> entriesForMetric(HealthHistoryMetric metric) {
    final source = state.allEntries.isNotEmpty
        ? state.allEntries
        : state.entries;
    return source.where((entry) => entry.metric == metric).toList();
  }

  List<HealthHistoryEntry> selectedMetricEntries() {
    return entriesForMetric(state.selectedMetric);
  }

  List<HealthHistoryEntry> selectedPeriodEntries() {
    final start = _periodStart();
    final end = _periodEnd();
    final filtered =
        selectedMetricEntries()
            .where(
              (entry) =>
                  !entry.recordedAt.isBefore(start) &&
                  entry.recordedAt.isBefore(end),
            )
            .toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final latestByBucket = <String, HealthHistoryEntry>{};
    for (final entry in filtered) {
      final key = _bucketKeyForEntry(entry);
      final existing = latestByBucket[key];
      if (existing == null || entry.recordedAt.isAfter(existing.recordedAt)) {
        latestByBucket[key] = entry;
      }
    }

    return latestByBucket.values.toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  double? summaryValue() {
    final periodEntries = selectedPeriodEntries();
    final entries = selectedMetricEntries();
    final source = periodEntries.isNotEmpty ? periodEntries : entries;
    if (source.isEmpty) return null;
    final total = source.fold<double>(0, (sum, entry) => sum + entry.value);
    return total / source.length;
  }

  String metricTitle() {
    return state.selectedMetric == HealthHistoryMetric.weight
        ? 'Cân nặng'
        : 'Chiều cao';
  }

  String unit() {
    return state.selectedMetric == HealthHistoryMetric.weight ? 'kg' : 'cm';
  }

  Future<void> seedCurrentValue({
    required HealthHistoryMetric metric,
    required double? value,
  }) async {
    state = state.copyWith(selectedMetric: metric);
    await load();
  }

  List<HealthHistoryEntry> _entriesFromHistory(HealthHistory history) {
    final metric = _presentationMetric(history.metric);
    final entries =
        history.points
            .map(
              (point) => HealthHistoryEntry(
                metric: metric,
                value: point.value,
                recordedAt: point.recordedAt,
              ),
            )
            .toList()
          ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (entries.isNotEmpty || history.currentValue == null) return entries;

    return [
      HealthHistoryEntry(
        metric: metric,
        value: history.currentValue!,
        recordedAt: _fallbackPointDate(history),
      ),
    ];
  }

  DateTime _fallbackPointDate(HealthHistory history) {
    final now = DateTime.now();
    if (!now.isBefore(history.startDate) && now.isBefore(history.endDate)) {
      return now;
    }

    final midpoint = history.startDate.add(
      Duration(
        milliseconds:
            history.endDate.difference(history.startDate).inMilliseconds ~/ 2,
      ),
    );
    return midpoint;
  }

  List<HealthHistoryEntry> _entriesFromChanges(HealthHistoryChanges changes) {
    return changes.changes
        .map(
          (change) => HealthHistoryEntry(
            metric: _presentationMetric(change.metric),
            value: change.value,
            recordedAt: change.recordedAt,
            change: change.change,
            direction: change.direction,
          ),
        )
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  HealthHistoryMetric _presentationMetric(HealthMetricType metric) {
    return metric == HealthMetricType.height
        ? HealthHistoryMetric.height
        : HealthHistoryMetric.weight;
  }

  HealthMetricType _domainMetric(HealthHistoryMetric metric) {
    return metric == HealthHistoryMetric.height
        ? HealthMetricType.height
        : HealthMetricType.weight;
  }

  HealthHistoryPeriodType _domainPeriod(HealthHistoryRange range) {
    switch (range) {
      case HealthHistoryRange.day:
        return HealthHistoryPeriodType.day;
      case HealthHistoryRange.week:
        return HealthHistoryPeriodType.week;
      case HealthHistoryRange.month:
        return HealthHistoryPeriodType.month;
    }
  }

  DateTime _movedDate(int direction) {
    switch (state.selectedRange) {
      case HealthHistoryRange.day:
        return state.cursorDate.add(Duration(days: direction));
      case HealthHistoryRange.week:
        return state.cursorDate.add(Duration(days: direction * 7));
      case HealthHistoryRange.month:
        return DateTime(
          state.cursorDate.year,
          state.cursorDate.month + direction,
          1,
        );
    }
  }

  DateTime _periodStart() {
    switch (state.selectedRange) {
      case HealthHistoryRange.day:
        return DateTime(
          state.cursorDate.year,
          state.cursorDate.month,
          state.cursorDate.day,
        );
      case HealthHistoryRange.week:
        final base = DateTime(
          state.cursorDate.year,
          state.cursorDate.month,
          state.cursorDate.day,
        );
        return base.subtract(Duration(days: base.weekday - 1));
      case HealthHistoryRange.month:
        return DateTime(state.cursorDate.year, state.cursorDate.month);
    }
  }

  DateTime _periodEnd() {
    switch (state.selectedRange) {
      case HealthHistoryRange.day:
        return _periodStart().add(const Duration(days: 1));
      case HealthHistoryRange.week:
        return _periodStart().add(const Duration(days: 7));
      case HealthHistoryRange.month:
        return DateTime(state.cursorDate.year, state.cursorDate.month + 1);
    }
  }

  String _bucketKeyForEntry(HealthHistoryEntry entry) {
    switch (state.selectedRange) {
      case HealthHistoryRange.day:
        final bucketHour = (entry.recordedAt.hour ~/ 4) * 4;
        return '${entry.recordedAt.year}-${entry.recordedAt.month}-${entry.recordedAt.day}-$bucketHour';
      case HealthHistoryRange.week:
        return '${entry.recordedAt.year}-${entry.recordedAt.month}-${entry.recordedAt.day}';
      case HealthHistoryRange.month:
        final weekStart = DateTime(
          entry.recordedAt.year,
          entry.recordedAt.month,
          entry.recordedAt.day,
        ).subtract(Duration(days: entry.recordedAt.weekday - 1));
        return '${weekStart.year}-${weekStart.month}-${weekStart.day}';
    }
  }
}
