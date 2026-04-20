import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../providers/add_medicine/add_medicine_provider.dart';
import 'add_medicine_action_card.dart';

class AddMedicineActionButtons extends ConsumerWidget {
  const AddMedicineActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addMedicineProvider.notifier);

    return Padding(
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
    );
  }
}
