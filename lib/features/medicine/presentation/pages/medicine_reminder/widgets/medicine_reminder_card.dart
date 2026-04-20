import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';
import 'medicine_reminder_info_card.dart';
import 'medicine_reminder_schedule_card.dart';
import 'medicine_reminder_toggle_card.dart';

class MedicineReminderCard extends ConsumerWidget {
  const MedicineReminderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final isAsNeeded = state.frequency == 'as_needed';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const MedicineReminderInfoCard(),
          if (!isAsNeeded) ...[
            SizedBox(height: 16.h),
            const MedicineReminderScheduleCard(),
            const MedicineReminderToggleCard(),
          ],
        ],
      ),
    );
  }
}
