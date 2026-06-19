import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../providers/prescription/prescription_provider.dart';
import '../../providers/prescription_details/prescription_details_provider.dart';
import 'widgets/deactivate_prescription_popup.dart';
import 'widgets/delete_prescription_popup.dart';
import 'widgets/prescription_details_card.dart';
import 'widgets/prescription_details_header.dart';
import 'widgets/prescription_details_skeleton.dart';

class PrescriptionDetailsPage extends ConsumerWidget {
  const PrescriptionDetailsPage({super.key, this.prescription});

  final Prescription? prescription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsState = ref.watch(prescriptionDetailsProvider(prescription));
    final current = detailsState.prescription;

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const PrescriptionDetailsHeader(),
              Expanded(
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
                  child: detailsState.isLoading
                      ? const PrescriptionDetailsSkeleton(
                          key: ValueKey('details-skeleton'),
                        )
                      : current == null
                      ? const SizedBox.shrink(key: ValueKey('details-empty'))
                      : ListView(
                          key: const ValueKey('details-content'),
                          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 10.h),
                          children: [
                            PrescriptionDetailsCard(
                              prescription: current,
                              onViewImage: () =>
                                  _showLargeImage(context, current),
                              onUpdate: () async {
                                final result = await context.push(
                                  AppRoutes.editPrescription,
                                  extra: current,
                                );
                                if (result == true) {
                                  await ref
                                      .read(prescriptionProvider.notifier)
                                      .fetchPrescriptions();
                                }
                              },
                              onDeactivate: () =>
                                  _confirmDeactivate(context, ref, current),
                              onDelete: () =>
                                  _confirmDelete(context, ref, current),
                              onActivate: () async {
                                final result = await context.push(
                                  AppRoutes.editPrescription,
                                  extra: current,
                                );
                                if (result == true) {
                                  await ref
                                      .read(prescriptionProvider.notifier)
                                      .fetchPrescriptions();
                                }
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Prescription prescription,
  ) {
    final detailsContext = context;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Delete Prescription Confirmation',
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
              Center(
                child: DeletePrescriptionPopup(
                  onConfirm: () async {
                    if (context.mounted) {
                      context.pop();
                    }
                    await _deletePrescription(
                      detailsContext,
                      ref,
                      prescription,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _confirmDeactivate(
    BuildContext context,
    WidgetRef ref,
    Prescription prescription,
  ) {
    final detailsContext = context;
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Deactivate Prescription Confirmation',
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
              Center(
                child: DeactivatePrescriptionPopup(
                  onConfirm: () async {
                    if (context.mounted) {
                      context.pop();
                    }
                    await _updateStatus(
                      detailsContext,
                      ref,
                      prescription,
                      'COMPLETED',
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    Prescription prescription,
    String newStatus,
  ) async {
    // ignore: unawaited_futures
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      ),
    );

    try {
      final updatePrescription = ref.read(updatePrescriptionProvider);
      await updatePrescription(
        id: prescription.id,
        doctorName: prescription.doctorName,
        clinicName: prescription.clinicName,
        note: prescription.note ?? '',
        startDate: prescription.startDate,
        endDate: prescription.endDate,
        status: newStatus,
      );

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      await ref.read(prescriptionProvider.notifier).fetchPrescriptions();

      if (context.mounted) {
        final msg = newStatus == 'ACTIVE'
            ? 'Kích hoạt đơn thuốc thành công'
            : 'Ngưng đơn thuốc thành công';
        AppToast.success(msg);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        AppToast.error(e);
      }
    }
  }

  Future<void> _deletePrescription(
    BuildContext context,
    WidgetRef ref,
    Prescription prescription,
  ) async {
    // ignore: unawaited_futures
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      ),
    );

    try {
      await ref
          .read(prescriptionProvider.notifier)
          .deletePrescription(prescription.id);

      if (context.mounted) {
        Navigator.of(context).pop();
        AppToast.success('Xóa đơn thuốc thành công');
        context.pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _showLargeImage(BuildContext context, Prescription prescription) {
    final imageUrl = prescription.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
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
}

