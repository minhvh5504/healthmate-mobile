import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_medication.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../providers/medicine_flow/medicine_flow_provider.dart';

class MedicineOptionsTitle extends ConsumerWidget {
  final UserMedication? medication;

  const MedicineOptionsTitle({super.key, this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicineProvider).activeMedications;
    final latestMedication = medications.cast<UserMedication?>().firstWhere(
      (m) => m?.id == medication?.id,
      orElse: () => medication,
    );

    final flowState = ref.watch(medicineFlowProvider);

    final name =
        latestMedication?.effectiveName ??
        flowState.name ??
        'medicine.no_name'.tr();
    final stock = latestMedication?.stockCount ?? 0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.typoBlack,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'medicine.stock_remaining'.tr(args: [stock.toString()]),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: stock == 0 ? const Color(0xFFD97706) : AppColors.typoHeading,
          ),
        ),
      ],
    );
  }
}
