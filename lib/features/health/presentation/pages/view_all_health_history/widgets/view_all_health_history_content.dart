import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/health_history/health_history_provider.dart';
import 'view_all_health_history_empty_state.dart';
import 'view_all_health_history_item.dart';
import 'view_all_health_history_skeleton.dart';

class ViewAllHealthHistoryContent extends StatelessWidget {
  final bool isLoading;
  final List<HealthHistoryEntry> entries;
  final String unit;
  final Future<void> Function() onRefresh;

  const ViewAllHealthHistoryContent({
    super.key,
    required this.isLoading,
    required this.entries,
    required this.unit,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF4F46E5),
      child: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        child: isLoading
            ? const ViewAllHealthHistorySkeleton(
                key: ValueKey('health-history-skeleton'),
              )
            : entries.isEmpty
            ? ListView(
                key: const ValueKey('health-history-empty'),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 120.h),
                  const ViewAllHealthHistoryEmptyState(),
                ],
              )
            : ListView.builder(
                key: const ValueKey('health-history-content'),
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return ViewAllHealthHistoryItem(
                    entry: entries[index],
                    unit: unit,
                  );
                },
              ),
      ),
    );
  }
}
