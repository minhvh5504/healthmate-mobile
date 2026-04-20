import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/config/routing/app_routes.dart';
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
    final medications = medicineState.reviewMedications;
    final medicineNotifier = ref.read(medicineProvider.notifier);
    final scanNotifier = ref.read(scanMedicineProvider.notifier);

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
                return FadeTransition(opacity: anim1, child: child);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline, // or LucideIcons.trash_2
                  color: AppColors.typoError,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'medicine.scan.action.delete_all'.tr(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoError,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFFCBD5E1),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if (medications.isNotEmpty)
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
                extra: {'name': '', 'isUpdate': false},
              );
            },
            height: 48.h,
            width: double.infinity,
          ),
      ],
    );
  }

  void _showSuccessPopup(BuildContext context, ScanMedicineNotifier notifier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MedicineSuccessPopup(
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
    );
  }
}
