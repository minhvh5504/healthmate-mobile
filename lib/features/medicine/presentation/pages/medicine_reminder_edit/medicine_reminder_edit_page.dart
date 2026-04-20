import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine_reminder_edit/medicine_reminder_edit_provider.dart';
import 'widgets/medicine_reminder_card.dart';
import 'widgets/medicine_reminder_header.dart';
import 'widgets/medicine_reminder_save_button.dart';
import 'widgets/medicine_reminder_title.dart';
import 'widgets/medicine_reminder_top_icon.dart';

class MedicineReminderEditPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> medication;

  const MedicineReminderEditPage({super.key, required this.medication});

  @override
  ConsumerState<MedicineReminderEditPage> createState() =>
      _MedicineReminderEditPageState();
}

class _MedicineReminderEditPageState extends ConsumerState<MedicineReminderEditPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineReminderEditProvider.notifier).init(widget.medication);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const MedicineReminderHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      const MedicineReminderTopIcon(),
                      SizedBox(height: 8.h),
                      const MedicineReminderTitle(),
                      SizedBox(height: 32.h),
                      const MedicineReminderCard(),
                      const MedicineReminderSaveButton(),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
