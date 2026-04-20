import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/create_user_medication.dart';
import '../medicine/medicine_provider.dart';
import 'medicine_review_notifier.dart';

/// Usecase create user medication
final createUserMedicationUseCaseProvider = Provider<CreateUserMedication>((
  ref,
) {
  return CreateUserMedication(ref.read(medicationRepositoryProvider));
});

final medicineReviewProvider =
    StateNotifierProvider<MedicineReviewNotifier, MedicineReviewState>((ref) {
      return MedicineReviewNotifier(
        ref,
        ref.read(createUserMedicationUseCaseProvider),
      );
    });
