import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/scan_medicine/scan_medicine_provider.dart';
import 'scan_tip_item.dart';
import 'scan_tutorial_page.dart';

class ScanPrescriptionPage extends ConsumerWidget {
  const ScanPrescriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanMedicineProvider);
    final notifier = ref.read(scanMedicineProvider.notifier);

    /// Set scan type on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setScanType(ScanType.prescription);
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
      title: 'Mẹo để chụp đơn thuốc',
      isLoading: state.isLoading,
      capturedImagePath: state.imagePath,
      onBack: notifier.onBack,
      onTakePhoto: notifier.onTakePhoto,
      onUploadPhoto: notifier.onUploadPhoto,
      tips: const [
        ScanTipItem(
          icon: Icon(Icons.description_outlined),
          text:
              'Đảm bảo toàn bộ đơn thuốc được căn giữa và rõ ràng trong khung.',
        ),
        ScanTipItem(
          icon: Icon(Icons.wb_sunny_outlined),
          text: 'Hạn chế ánh sáng chói, bóng, và ảnh mờ.',
        ),
        ScanTipItem(
          icon: Icon(Icons.calendar_today_outlined),
          text:
              'Để có kết quả tốt nhất, sử dụng đơn thuốc in điện tử. Các đơn viết tay có thể không được quét chính xác.',
        ),
      ],
    );
  }
}
