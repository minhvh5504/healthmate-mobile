import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/medicine/medicine_provider.dart';
import 'review_medication_card.dart';

class ScanMedicationList extends ConsumerWidget {
  const ScanMedicationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineProvider);
    final medications = medicineState.reviewMedications;

    if (medications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: medications.map((med) => ReviewMedicationCard(medication: med)).toList(),
    );
  }
}
