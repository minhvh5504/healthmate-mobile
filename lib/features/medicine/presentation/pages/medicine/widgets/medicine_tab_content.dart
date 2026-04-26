import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/medicine/medicine_provider.dart';
import 'medicine_schedule_content.dart';
import 'medicine_cabinet_content.dart';

class MedicineTabContent extends ConsumerWidget {
  const MedicineTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);

    switch (state.selectedTab) {
      case MedicineTab.schedule:
        return const MedicineScheduleContent();
      case MedicineTab.cabinet:
        return const MedicineCabinetContent();
    }
  }
}
