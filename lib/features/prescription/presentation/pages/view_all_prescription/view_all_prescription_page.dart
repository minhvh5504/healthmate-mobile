import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/constant_url.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/view_all_prescription/view_all_prescription_provider.dart';
import '../prescription/widgets/prescription_history_item.dart';
import 'widgets/view_all_prescription_skeleton.dart';

class ViewAllPrescriptionPage extends ConsumerWidget {
  const ViewAllPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viewAllPrescriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(viewAllPrescriptionProvider.notifier)
                      .fetchPrescriptions(),
                  color: const Color(0xFF4F46E5),
                  child: PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
                          return FadeThroughTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            fillColor: Colors.transparent,
                            child: child,
                          );
                        },
                    child: state.isLoading
                        ? const ViewAllPrescriptionSkeleton(
                            key: ValueKey('history-skeleton'),
                          )
                        : state.historyPrescriptions.isEmpty
                        ? ListView(
                            key: const ValueKey('history-empty'),
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 120.h),
                              _buildEmptyState(),
                            ],
                          )
                        : ListView.builder(
                            key: const ValueKey('history-content'),
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              12.h,
                              20.w,
                              20.h,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.historyPrescriptions.length,
                            itemBuilder: (context, index) {
                              final prescription =
                                  state.historyPrescriptions[index];
                              return PrescriptionHistoryItem(
                                prescription: prescription,
                                onTap: () => context.push(
                                  AppRoutes.prescriptionDetails,
                                  extra: prescription,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 10.h),
      child: SizedBox(
        height: 44.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.sp,
                    color: AppColors.typoBlack,
                  ),
                ),
              ),
            ),
            Text(
              'prescription.history_title'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.typoBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.notFound,
            width: 180.w,
            height: 180.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            'prescription.history_empty_state'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoBody,
            ),
          ),
        ],
      ),
    );
  }
}
