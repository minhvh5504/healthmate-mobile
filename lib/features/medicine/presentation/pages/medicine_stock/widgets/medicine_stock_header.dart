import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/medicine_stock/medicine_stock_provider.dart';
import '../../medicine_detail_preview/widgets/medicine_details_header.dart';

class MedicineStockHeader extends ConsumerWidget {
  const MedicineStockHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineStockProvider);

    return MedicineDetailsHeader(
      name: state.medication['name'] ?? '',
      manufacturer: state.medication['manufacturer'] ?? '',
      onBack: () => context.pop(),
    );
  }
}
