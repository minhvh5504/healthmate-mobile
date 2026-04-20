import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';
import '../../medicine_detail_preview/widgets/medicine_details_header.dart';

class MedicineReminderHeader extends ConsumerWidget {
  const MedicineReminderHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    
    return MedicineDetailsHeader(
      name: state.medication['name'] ?? '',
      manufacturer: state.medication['manufacturer'] ?? '',
      onBack: () => context.pop(),
    );
  }
}
