import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/prescription/prescription_provider.dart';
import 'widgets/prescription_active_section.dart';
import 'widgets/prescription_add_button.dart';
import 'widgets/prescription_empty_state.dart';
import 'widgets/prescription_header.dart';
import 'widgets/prescription_history_section.dart';
import 'widgets/prescription_skeleton.dart';

class PrescriptionPage extends ConsumerWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prescriptionProvider);
    final notifier = ref.read(prescriptionProvider.notifier);

    final isInitialLoading = state.isLoading && state.isInitialLoad;

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const PrescriptionHeader(),
                  Expanded(
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
                      child: isInitialLoading
                          ? const PrescriptionSkeleton(
                              key: ValueKey('prescription-skeleton'),
                            )
                          : _buildBody(
                              context,
                              state,
                              notifier,
                              key: const ValueKey('prescription-content'),
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20.w,
                right: 20.w,
                bottom: 14.h,
                child: const PrescriptionAddButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PrescriptionState state,
    PrescriptionNotifier notifier, {
    Key? key,
  }) {
    final hasActive = state.activePrescriptions.isNotEmpty;
    final hasHistory = state.historyPrescriptions.isNotEmpty;

    if (!hasActive && !hasHistory) {
      return PrescriptionEmptyState(
        key: key,
        onRefresh: notifier.fetchPrescriptions,
      );
    }

    return RefreshIndicator(
      key: key,
      onRefresh: notifier.fetchPrescriptions,
      color: const Color(0xFF4F46E5),
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 86.h),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (hasActive) ...[
            PrescriptionActiveSection(
              prescriptions: state.activePrescriptions,
              onPrescriptionTap: (item) =>
                  context.push(AppRoutes.prescriptionDetails, extra: item),
            ),
          ],
          if (hasHistory) ...[
            SizedBox(height: 16.h),
            PrescriptionHistorySection(
              prescriptions: state.historyPrescriptions,
              onViewAll: () => context.push(AppRoutes.viewAllPrescription),
              onPrescriptionTap: (item) =>
                  context.push(AppRoutes.prescriptionDetails, extra: item),
            ),
          ],
        ],
      ),
    );
  }
}
