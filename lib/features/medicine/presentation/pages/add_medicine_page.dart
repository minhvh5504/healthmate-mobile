import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';

import '../providers/add_medicine/add_medicine_provider.dart';
import '../widgets/add_medicine/add_medicine_action_card.dart';
import '../widgets/add_medicine/add_medicine_header.dart';
import '../widgets/add_medicine/add_medicine_search_bar.dart';

class AddMedicinePage extends ConsumerWidget {
  const AddMedicinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addMedicineProvider.notifier);

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
            children: [
              AddMedicineHeader(
                title: 'medicine.add_medicine.title'.tr(),
                onClose: notifier.onClose,
              ),

              SizedBox(height: 8.h),

              AddMedicineSearchBar(
                hintText: 'medicine.add_medicine.search_hint'.tr(),
                onChanged: notifier.updateSearchQuery,
              ),

              SizedBox(height: 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: AddMedicineActionCard(
                        icon: LucideIcons.scanLine,
                        label: 'medicine.add_medicine.scan_prescription'.tr(),
                        onTap: notifier.onScanPrescription,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AddMedicineActionCard(
                        icon: LucideIcons.camera,
                        label: 'medicine.add_medicine.scan_box'.tr(),
                        onTap: notifier.onScanMedicineBox,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
