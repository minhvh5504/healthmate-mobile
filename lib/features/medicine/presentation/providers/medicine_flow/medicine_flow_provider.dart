import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'medicine_flow_notifier.dart';

final medicineFlowProvider =
    StateNotifierProvider<MedicineFlowNotifier, MedicineFlowState>((ref) {
      return MedicineFlowNotifier(ref);
    });
