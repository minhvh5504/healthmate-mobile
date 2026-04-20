import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/add_medicine/add_medicine_provider.dart';
import 'add_medicine_search_bar.dart';

class AddMedicineSearchInput extends ConsumerStatefulWidget {
  const AddMedicineSearchInput({super.key});

  @override
  ConsumerState<AddMedicineSearchInput> createState() =>
      _AddMedicineSearchInputState();
}

class _AddMedicineSearchInputState extends ConsumerState<AddMedicineSearchInput> {
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
    final state = ref.watch(addMedicineProvider);
    final notifier = ref.read(addMedicineProvider.notifier);

    // Sync input field with global query state
    if (_searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
    }

    return AddMedicineSearchBar(
      controller: _searchController,
      hintText: 'medicine.add_medicine.search_hint'.tr(),
      showCancel: state.isSearchMode,
      showClear: state.isSearchMode,
      onCancel: () {
        _searchController.clear();
        notifier.cancelSearch();
      },
      onChanged: notifier.updateSearchQuery,
    );
  }
}
