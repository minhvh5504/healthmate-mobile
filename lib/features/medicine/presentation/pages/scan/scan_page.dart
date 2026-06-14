import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/scan_task.dart';
import '../../providers/medicine/medicine_provider.dart';
import 'widgets/scan_action_buttons.dart';
import 'widgets/scan_header.dart';
import 'widgets/scan_medication_list.dart';
import 'widgets/scan_page_loading_overlay.dart';
import 'widgets/scan_results_info.dart';

class ScanPage extends ConsumerStatefulWidget {
  final String taskId;

  const ScanPage({super.key, required this.taskId});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineProvider.notifier).selectTaskForReview(widget.taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineProvider);
    final scanTask = medicineState.scanTasks.cast<ScanTask?>().firstWhere(
      (task) => task?.id == widget.taskId,
      orElse: () => null,
    );
    final isFailed = scanTask?.status == ScanStatus.failed;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4FB),
      appBar: ScanHeader(
        title: isFailed ? 'medicine.scan.unrecognized_title'.tr() : null,
      ),
      body: SafeArea(
        top: false,
        child: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 8.h,
                  bottom: isFailed ? 152.h : 132.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.h),
                    ScanResultsInfo(taskId: widget.taskId),
                    SizedBox(height: 24.h),
                    if (!isFailed) const ScanMedicationList(),
                  ],
                ),
              ),
              Positioned(
                left: 24.w,
                right: 24.w,
                bottom: 12.h,
                child: ScanActionButtons(taskId: widget.taskId),
              ),
              const ScanPageLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}
