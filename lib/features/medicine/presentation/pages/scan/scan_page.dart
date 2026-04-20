import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4FB),
      appBar: const ScanHeader(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                const ScanResultsInfo(),
                SizedBox(height: 24.h),
                const ScanMedicationList(),
                SizedBox(height: 70.h),
                ScanActionButtons(taskId: widget.taskId),
              ],
            ),
          ),
          const ScanPageLoadingOverlay(),
        ],
      ),
    );
  }
}
