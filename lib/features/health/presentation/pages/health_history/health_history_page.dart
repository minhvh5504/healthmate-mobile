import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/core/routing/app_routes.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/health/domain/entities/health_history.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/height_metric_popup.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/weight_metric_popup.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_add_button.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health_history/widgets/health_history_content.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';

class HealthHistoryPage extends ConsumerStatefulWidget {
  final HealthHistoryMetric metric;

  const HealthHistoryPage({super.key, required this.metric});

  @override
  ConsumerState<HealthHistoryPage> createState() => _HealthHistoryPageState();
}

class _HealthHistoryPageState extends ConsumerState<HealthHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadMetricHistory);
  }

  @override
  void didUpdateWidget(covariant HealthHistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.metric != widget.metric) {
      Future.microtask(_loadMetricHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(healthHistoryProvider);
    final entries = historyState.entries
        .where((entry) => entry.metric == widget.metric)
        .toList();
    final remoteHistory = historyState.remoteHistory;
    final isCurrentMetricHistory =
        remoteHistory != null &&
        ((widget.metric == HealthHistoryMetric.weight &&
                remoteHistory.metric == HealthMetricType.weight) ||
            (widget.metric == HealthHistoryMetric.height &&
                remoteHistory.metric == HealthMetricType.height));
    final summaryValue = isCurrentMetricHistory
        ? remoteHistory.averageValue
        : null;
    final currentValue = isCurrentMetricHistory
        ? remoteHistory.currentValue ?? _currentValue()
        : _currentValue();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            HealthHistoryContent(
              title: _metricTitle(),
              unit: _unit(),
              metric: widget.metric,
              range: historyState.selectedRange,
              cursorDate: historyState.cursorDate,
              entries: entries,
              currentValue: currentValue,
              onRangeChanged: _changeRange,
              onPreviousPeriod: () => _movePeriod(-1),
              onNextPeriod: () => _movePeriod(1),
              onHistoryTap: () => context.push(
                AppRoutes.viewAllHealthHistory,
                extra: widget.metric,
              ),
            ),
            HealthHistoryAddButton(
              onTap: () => _showMetricPopup(currentValue ?? summaryValue ?? 0),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMetricHistory() async {
    final profile = ref.read(healthProvider).userProfile;
    final value = widget.metric == HealthHistoryMetric.weight
        ? profile?.weightKg
        : profile?.heightCm;
    await ref
        .read(healthHistoryProvider.notifier)
        .init(metric: widget.metric, currentValue: value);
  }

  void _changeRange(HealthHistoryRange range) {
    ref.read(healthHistoryProvider.notifier).changeRange(range);
  }

  void _movePeriod(int direction) {
    ref.read(healthHistoryProvider.notifier).movePeriod(direction);
  }

  double? _currentValue() {
    final profile = ref.watch(healthProvider).userProfile;
    return widget.metric == HealthHistoryMetric.weight
        ? profile?.weightKg
        : profile?.heightCm;
  }

  String _metricTitle() {
    return widget.metric == HealthHistoryMetric.weight
        ? 'health.weight'.tr()
        : 'health.height'.tr();
  }

  String _unit() {
    return widget.metric == HealthHistoryMetric.weight ? 'kg' : 'cm';
  }

  void _showMetricPopup(double initialValue) {
    final popup = widget.metric == HealthHistoryMetric.weight
        ? WeightMetricPopup(initialValue: initialValue)
        : HeightMetricPopup(initialValue: initialValue);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Health Metric Popup',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(child: popup),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeScaleTransition(animation: anim1, child: child);
      },
    );
  }
}
