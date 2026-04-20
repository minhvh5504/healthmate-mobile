import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'medicine_options_notifier.dart';

final medicineOptionsProvider =
    StateNotifierProvider<MedicineOptionsNotifier, MedicineOptionsState>(
  (ref) => MedicineOptionsNotifier(ref),
);
