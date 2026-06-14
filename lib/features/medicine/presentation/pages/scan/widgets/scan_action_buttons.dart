import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../domain/entities/scan_task.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../providers/scan_medicine/scan_medicine_provider.dart';
import 'delete_scan_task_popup.dart';
import 'medicine_success_popup.dart';

class ScanActionButtons extends ConsumerWidget {
  final String taskId;

  const ScanActionButtons({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final scanTask = medicineState.scanTasks.cast<ScanTask?>().firstWhere(
      (task) => task?.id == taskId,
      orElse: () => null,
    );
    final isFailed = scanTask?.status == ScanStatus.failed;
    final medications = medicineState.reviewMedications;
    final hasMatchedMedications = medications.any(
      (med) => med['isMatched'] == true,
    );
    final medicineNotifier = ref.read(medicineProvider.notifier);
    final scanNotifier = ref.read(scanMedicineProvider.notifier);

    if (isFailed) {
      return _buildFailedActions(context, medicineNotifier);
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
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
                            medicineNotifier.deleteScanTask(taskId);
                            context.pop();
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
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
            );
          },
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'medicine.scan.action.delete_all'.tr(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoError,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if (hasMatchedMedications)
          Button(
            text: 'medicine.scan.action.add_to_cabinet'.tr(),
            onPressed: () async {
              final success = await scanNotifier.saveMedicinesToCabinet(taskId);
              if (success && context.mounted) {
                _showSuccessPopup(context, scanNotifier);
              }
            },
            height: 48.h,
            width: double.infinity,
          )
        else
          Button(
            text: 'medicine.scan.action.add_manually'.tr(),
            onPressed: () {
              medicineNotifier.deleteScanTask(taskId);
              context.pushReplacement(
                AppRoutes.medicineDetailPreview,
                extra: {
                  'name': medications.isNotEmpty
                      ? medications.first['name']?.toString() ?? ''
                      : '',
                  'isUpdate': false,
                },
              );
            },
            height: 48.h,
            width: double.infinity,
          ),
      ],
    );
  }

  Widget _buildFailedActions(BuildContext context, MedicineNotifier notifier) {
    return Column(
      children: [
        Button(
          text: 'medicine.scan.action.skip'.tr(),
          onPressed: () {
            notifier.deleteScanTask(taskId);
            context.go(AppRoutes.medicine);
          },
          color: Colors.white,
          textColor: AppColors.typoError,
          borderColor: const Color(0xFFC9C3DD),
          height: 56.h,
          width: double.infinity,
        ),
        SizedBox(height: 12.h),
        Button(
          text: 'medicine.scan.retry'.tr(),
          onPressed: () {
            context.pushReplacement(AppRoutes.scanMedicineBox, extra: taskId);
          },
          height: 56.h,
          width: double.infinity,
        ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, ScanMedicineNotifier notifier) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Medicine Success',
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
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
