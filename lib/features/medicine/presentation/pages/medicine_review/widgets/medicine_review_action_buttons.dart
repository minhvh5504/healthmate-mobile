import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/app_router.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../providers/medicine_flow/medicine_flow_provider.dart';
import '../../../providers/medicine_review/medicine_review_notifier.dart';
import '../../../providers/medicine_review/medicine_review_provider.dart';
import '../../../providers/scan_medicine/scan_medicine_provider.dart';
import '../../scan/widgets/delete_scan_task_popup.dart';
import '../../scan/widgets/medicine_success_popup.dart';
import 'cancel_medicine_addition_popup.dart';

class MedicineReviewActionButtons extends ConsumerWidget {
  final String? taskId;

  const MedicineReviewActionButtons({super.key, this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(medicineReviewProvider, (previous, next) {
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'Success Confirmation',
          barrierColor: Colors.black.withValues(alpha: 0.2),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, anim1, anim2) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppColors.backgroundGradient,
                    ),
                  ),
                  Center(
                    child: MedicineSuccessPopup(
                      onAddNew: () {
                        Navigator.pop(context);
                        ref.read(medicineFlowProvider.notifier).init({});
                        AppRouter.router.go(AppRoutes.addMedicine);
                      },
                      onViewCabinet: () {
                        Navigator.pop(context);
                        AppRouter.router.go(AppRoutes.medicine);
                      },
                      onComplete: () {
                        Navigator.pop(context);
                        AppRouter.router.go(AppRoutes.home);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    });

    final isBatchReview = taskId != null;
    final isEmpty = isBatchReview
        ? ref.watch(medicineProvider).reviewMedications.isEmpty
        : ref.watch(medicineReviewProvider).medication.isEmpty;

    if (isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: taskId != null
          ? _buildScanActions(context, ref, taskId!)
          : _buildSingleMedicineActions(context, ref),
    );
  }

  Widget _buildScanActions(BuildContext context, WidgetRef ref, String tid) {
    final medicineNotifier = ref.read(medicineProvider.notifier);
    final scanNotifier = ref.read(scanMedicineProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button(
          text: 'medicine.scan.action.delete_all'.tr(),
          onPressed: () =>
              _showDeleteConfirmation(context, medicineNotifier, tid),
          color: Colors.white,
          textColor: AppColors.typoError,
          height: 52.h,
          width: double.infinity,
        ),
        SizedBox(height: 12.h),
        Button(
          text: 'medicine.scan.action.add_to_cabinet'.tr(),
          onPressed: () async {
            final success = await scanNotifier.saveMedicinesToCabinet(tid);
            if (success && context.mounted) {
              _showSuccessPopup(context, scanNotifier);
            }
          },
          height: 48.h,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildSingleMedicineActions(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(medicineReviewProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button(
          text: 'Hủy thêm thuốc',
          onPressed: () => _showCancelConfirmation(context, notifier),
          color: Colors.white,
          textColor: AppColors.typoError,
          height: 48.h,
          width: double.infinity,
        ),
        SizedBox(height: 12.h),
        Button(
          text: 'Thêm vào hộp thuốc',
          onPressed: () => notifier.onSaveInfo(),
          height: 48.h,
          width: double.infinity,
        ),
      ],
    );
  }

  void _showCancelConfirmation(
    BuildContext context,
    MedicineReviewNotifier notifier,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cancel Confirmation',
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
                child: CancelMedicineAdditionPopup(
                  onConfirm: () => notifier.onCancel(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    MedicineNotifier notifier,
    String tid,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Delete Confirmation',
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
                child: DeleteScanTaskPopup(
                  onConfirm: () {
                    notifier.deleteScanTask(tid);
                    context.pop(); // Close popup
                    context.pop(); // Close review page
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessPopup(BuildContext context, ScanMedicineNotifier notifier) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Success Confirmation',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
              ),
              Center(
                child: MedicineSuccessPopup(
                  onAddNew: () {
                    context.pop();
                    notifier.onAddNew();
                  },
                  onViewCabinet: () {
                    context.pop();
                    notifier.onViewCabinet();
                  },
                  onComplete: () {
                    context.pop();
                    notifier.onComplete();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
