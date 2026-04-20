import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/scan_medicine/scan_medicine_provider.dart';
import 'scan_tip_item.dart';
import 'scan_tutorial_page.dart';

class ScanMedicineBoxPage extends ConsumerWidget {
  const ScanMedicineBoxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanMedicineProvider);
    final notifier = ref.read(scanMedicineProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setScanType(ScanType.medicineBox);
    });

    ref.listen(scanMedicineProvider.select((s) => s.errorMessage), (
      previous,
      next,
    ) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
      }
    });

    return ScanTutorialPage(
      title: 'medicine.scan.tips.box_title'.tr(),
      isLoading: state.isLoading,
      capturedImagePath: state.imagePath,
      onBack: notifier.onBack,
      onTakePhoto: notifier.onTakePhoto,
      onUploadPhoto: notifier.onUploadPhoto,
      tips: [
        ScanTipItem(
          icon: const Icon(Icons.wb_sunny_outlined),
          text: 'medicine.scan.tips.box_lighting'.tr(),
        ),
        ScanTipItem(
          icon: const Icon(Icons.crop_square_outlined),
          text: 'medicine.scan.tips.box_content'.tr(),
        ),
        ScanTipItem(
          icon: const Icon(Icons.notes_rounded),
          text: 'medicine.scan.tips.box_clarity'.tr(),
        ),
      ],
    );
  }
}
