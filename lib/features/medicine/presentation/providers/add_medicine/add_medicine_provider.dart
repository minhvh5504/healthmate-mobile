import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_medicine_notifier.dart';

final addMedicineProvider =
    StateNotifierProvider.autoDispose<AddMedicineNotifier, AddMedicineState>(
  (ref) => AddMedicineNotifier(ref),
);
