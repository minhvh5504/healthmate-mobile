import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';

class MedicineReminderSaveButton extends ConsumerWidget {
  const MedicineReminderSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final notifier = ref.read(medicineReminderProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Button(
        text: 'medicine_stock.continue'.tr(),
        onPressed: notifier.onSave,
        isLoading: state.isLoading,
        height: 48.h,
        width: double.infinity,
      ),
    );
  }
}
