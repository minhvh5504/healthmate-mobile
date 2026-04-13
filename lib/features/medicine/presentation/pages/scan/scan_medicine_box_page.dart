import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/scan_medicine/scan_medicine_provider.dart';
import '../../widgets/scan/scan_tip_item.dart';
import 'scan_tutorial_page.dart';

class ScanMedicineBoxPage extends ConsumerWidget {
  const ScanMedicineBoxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanMedicineProvider);
    final notifier = ref.read(scanMedicineProvider.notifier);

    /// Set scan type on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setScanType(ScanType.medicineBox);
    });

    /// Listen for error messages
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
      title: 'Mẹo để chụp ảnh thuốc rõ ràng',
      isLoading: state.isLoading,
      capturedImagePath: state.imagePath,
      onBack: notifier.onBack,
      onTakePhoto: notifier.onTakePhoto,
      onUploadPhoto: notifier.onUploadPhoto,
      tips: const [
        ScanTipItem(
          icon: Icon(Icons.wb_sunny_outlined),
          text: 'Sử dụng ảnh rõ sáng, sắc nét. Tránh ánh sáng chói hoặc mờ.',
        ),
        ScanTipItem(
          icon: Icon(Icons.crop_square_outlined),
          text:
              'Chụp ảnh bao bì thuốc (hộp hoặc chai). Bạn có thể chụp nhiều loại trong cùng một ảnh.',
        ),
        ScanTipItem(
          icon: Icon(Icons.notes_rounded),
          text: 'Đảm bảo tất cả tên thuốc đều rõ ràng và dễ đọc.',
        ),
      ],
    );
  }
}
