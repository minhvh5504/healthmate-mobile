import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_medication.dart';
import '../../../providers/medicine/medicine_provider.dart';

class MedicineOptionsLabel extends ConsumerWidget {
  final UserMedication? medication;

  const MedicineOptionsLabel({super.key, this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicineProvider).activeMedications;
    final latestMedication = medications.cast<UserMedication?>().firstWhere(
      (m) => m?.id == medication?.id,
      orElse: () => medication,
    );

    return Text(
      _frequencyLabel(latestMedication),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: AppColors.typoBody.withValues(alpha: 0.8),
      ),
    );
  }

  String _frequencyLabel(UserMedication? medication) {
    if (medication == null) return 'medicine.only_if_needed'.tr();

    String? repeatType = medication.frequency;
    final schedules = medication.reminderSchedules;
    if (schedules != null && schedules.isNotEmpty) {
      final first = schedules.first;
      if (first is Map<String, dynamic>) {
        repeatType = first['repeatType']?.toString() ?? repeatType;
      } else if (first is Map) {
        repeatType = first['repeatType']?.toString() ?? repeatType;
      }
    }

    switch (repeatType) {
      case 'daily':
        return 'medicine.daily'.tr();
      case 'specific_days':
        return 'medicine.reminder.specific_days'.tr();
      case 'as_needed':
      default:
        return 'medicine.only_if_needed'.tr();
    }
  }
}
