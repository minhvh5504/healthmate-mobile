import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/create_user_medication.dart';
import '../../../domain/usecases/delete_scan_task.dart';
import '../../../domain/usecases/scan_medication.dart';
import '../medicine/medicine_provider.dart';
import 'scan_medicine_notifier.dart';

export 'scan_medicine_notifier.dart';

/// UseCase Scan
final scanMedicationUseCaseProvider = Provider<ScanMedication>((ref) {
  return ScanMedication(ref.read(medicationRepositoryProvider));
});

/// UseCase Create User Medication
final createUserMedicationUseCaseProvider = Provider<CreateUserMedication>((
  ref,
) {
  return CreateUserMedication(ref.read(medicationRepositoryProvider));
});

/// UseCase Delete Scan Task
final deleteScanTaskUseCaseProvider = Provider<DeleteScanTask>((ref) {
  return DeleteScanTask(ref.read(medicationRepositoryProvider));
});

/// Main Provider
final scanMedicineProvider =
    StateNotifierProvider.autoDispose<ScanMedicineNotifier, ScanMedicineState>(
      (ref) => ScanMedicineNotifier(
        ref,
        ref.read(scanMedicationUseCaseProvider),
        ref.read(createUserMedicationUseCaseProvider),
        ref.read(deleteScanTaskUseCaseProvider),
      ),
    );
