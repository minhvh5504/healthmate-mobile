import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/add_medicine/add_medicine_provider.dart';
import 'add_medicine_search_result_item.dart';

class AddMedicineSearchView extends ConsumerWidget {
  const AddMedicineSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMedicineProvider);
    final notifier = ref.read(addMedicineProvider.notifier);

    if (state.isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (state.searchQuery.isEmpty) {
      return const Spacer();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
            child: Text(
              'medicine.add_medicine.search_results'.tr().toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: state.searchResults.length + 1,
              itemBuilder: (context, index) {
                if (index == state.searchResults.length) {
                  return AddMedicineSearchResultItem(
                    title: state.searchQuery,
                    subtitle: 'medicine.add_medicine.custom_medicine'.tr(),
                    onTap: () => notifier.onCustomMedicine(state.searchQuery),
                  );
                }

                final medication = state.searchResults[index];
                return AddMedicineSearchResultItem(
                  title: medication.name,
                  subtitle: medication.genericName ?? 'medicine.preview.other'.tr(),
                  manufacturer: medication.manufacturer,
                  onTap: () => notifier.onSelectMedication(medication),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
