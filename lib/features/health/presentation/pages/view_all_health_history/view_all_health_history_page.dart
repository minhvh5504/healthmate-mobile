import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/health_history/health_history_provider.dart';
import '../../providers/view_all_health_history/view_all_health_history_provider.dart';
import 'widgets/view_all_health_history_content.dart';
import 'widgets/view_all_health_history_header.dart';

class ViewAllHealthHistoryPage extends ConsumerStatefulWidget {
  final HealthHistoryMetric metric;

  const ViewAllHealthHistoryPage({super.key, required this.metric});

  @override
  ConsumerState<ViewAllHealthHistoryPage> createState() =>
      _ViewAllHealthHistoryPageState();
}

class _ViewAllHealthHistoryPageState
    extends ConsumerState<ViewAllHealthHistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchFilteredHistory);
  }

  Future<void> _fetchFilteredHistory() {
    return ref
        .read(viewAllHealthHistoryProvider.notifier)
        .fetchHealthHistory(metric: widget.metric);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewAllHealthHistoryProvider);
    final entries =
        state.entries.where((entry) => entry.metric == widget.metric).toList()
          ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              ViewAllHealthHistoryHeader(title: _title()),
              Expanded(
                child: ViewAllHealthHistoryContent(
                  isLoading: state.isLoading,
                  entries: entries,
                  unit: _unit(),
                  onRefresh: _fetchFilteredHistory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title() {
    return widget.metric == HealthHistoryMetric.weight
        ? 'health.view_weight_history_title'.tr()
        : 'health.view_height_history_title'.tr();
  }

  String _unit() => widget.metric == HealthHistoryMetric.weight ? 'kg' : 'cm';
}
