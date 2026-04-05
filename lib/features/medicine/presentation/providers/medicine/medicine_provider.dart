import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'medicine_notifier.dart';

/// Global [StateNotifierProvider] for the Medicine screen.
final medicineProvider = StateNotifierProvider<MedicineNotifier, MedicineState>(
  (ref) => MedicineNotifier(ref),
);
