import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/add_medicine/add_medicine_provider.dart';
import 'widgets/add_medicine_action_buttons.dart';
import 'widgets/add_medicine_header.dart';
import 'widgets/add_medicine_search_input.dart';
import 'widgets/add_medicine_search_view.dart';

class AddMedicinePage extends ConsumerWidget {
  const AddMedicinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMedicineProvider);
    final notifier = ref.read(addMedicineProvider.notifier);
    final isSearchMode = state.isSearchMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF4F6FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSearchMode) ...[
                AddMedicineHeader(
                  title: 'medicine.add_medicine.title'.tr(),
                  onClose: notifier.onClose,
                ),
                SizedBox(height: 8.h),
              ] else
                SizedBox(height: 16.h),
                
              const AddMedicineSearchInput(),
              
              if (isSearchMode)
                const AddMedicineSearchView()
              else ...[
                SizedBox(height: 24.h),
                const AddMedicineActionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
