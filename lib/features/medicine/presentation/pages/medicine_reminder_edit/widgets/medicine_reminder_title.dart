import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicineReminderTitle extends StatelessWidget {
  const MedicineReminderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'medicine.reminder.title'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1E293B),
        height: 1.2,
      ),
    );
  }
}
