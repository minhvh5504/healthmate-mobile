import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../medicine/medicine_provider.dart';
import '../../../domain/usecases/search_medications.dart';
export 'add_medicine_notifier.dart';
import 'add_medicine_notifier.dart';

/// UseCase Provider for Search
final searchMedicationsUseCaseProvider = Provider<SearchMedications>((ref) {
  return SearchMedications(ref.read(medicationRepositoryProvider));
});

/// Provider
final addMedicineProvider =
    StateNotifierProvider<AddMedicineNotifier, AddMedicineState>(
      (ref) => AddMedicineNotifier(
        ref: ref,
        searchMedications: ref.read(searchMedicationsUseCaseProvider),
      ),
    );
