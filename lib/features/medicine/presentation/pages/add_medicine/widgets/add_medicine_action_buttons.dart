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
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          Text(
            'medicine.add_medicine.quick_add_by'.tr(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF68758C),
            ),
          ),
          SizedBox(height: 26.h),
          AddMedicineActionCard(
            icon: LucideIcons.camera,
            label: 'medicine.add_medicine.start_scan'.tr(),
            onTap: notifier.onScanMedicineBox,
          ),
        ],
      ),
    );
  }
}
