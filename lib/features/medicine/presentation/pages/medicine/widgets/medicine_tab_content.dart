import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/medicine/medicine_provider.dart';
import 'medicine_empty_state.dart';
import 'medicine_cabinet_content.dart';

class MedicineTabContent extends ConsumerWidget {
  const MedicineTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);

    switch (state.selectedTab) {
      case MedicineTab.schedule:
        return MedicineEmptyState(onAddMedicine: notifier.onAddMedicine);
      case MedicineTab.cabinet:
        return const MedicineCabinetContent();
    }
  }
}
