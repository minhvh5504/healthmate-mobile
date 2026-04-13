import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'scan_medicine_notifier.dart';
import '../../../domain/usecases/scan_medication.dart';
import '../medicine/medicine_provider.dart';
import 'scan_medicine_notifier.dart';

final scanMedicationUseCaseProvider = Provider<ScanMedication>((ref) {
  return ScanMedication(ref.read(medicationRepositoryProvider));
});

/// Provider
final scanMedicineProvider =
    StateNotifierProvider<ScanMedicineNotifier, ScanMedicineState>(
      (ref) => ScanMedicineNotifier(
        ref: ref,
        scanMedication: ref.read(scanMedicationUseCaseProvider),
      ),
    );
