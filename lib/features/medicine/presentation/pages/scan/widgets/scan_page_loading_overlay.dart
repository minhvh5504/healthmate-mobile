import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/scan_medicine/scan_medicine_provider.dart';

class ScanPageLoadingOverlay extends ConsumerWidget {
  const ScanPageLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanMedicineProvider);

    if (!scanState.isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withValues(alpha: 0.1),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
