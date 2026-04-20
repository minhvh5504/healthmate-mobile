import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/medicine_detail_preview/medicine_detail_preview_provider.dart';
import '../../add_medicine/widgets/add_medicine_search_bar.dart';

class MedicineDetailSearchInput extends ConsumerStatefulWidget {
  const MedicineDetailSearchInput({super.key});

  @override
  ConsumerState<MedicineDetailSearchInput> createState() =>
      _MedicineDetailSearchInputState();
}

class _MedicineDetailSearchInputState
    extends ConsumerState<MedicineDetailSearchInput> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineDetailPreviewProvider);
    final notifier = ref.read(medicineDetailPreviewProvider.notifier);

    if (_searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
    }

    return AddMedicineSearchBar(
      controller: _searchController,
      hintText: 'medicine.add_medicine.search_hint'.tr(),
      showCancel: true,
      showClear: true,
      onCancel: () {
        _searchController.clear();
        notifier.cancelSearch();
      },
      onChanged: notifier.updateSearchQuery,
    );
  }
}
