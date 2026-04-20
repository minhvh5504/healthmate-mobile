import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine_flow/medicine_flow_provider.dart';
import '../../providers/medicine_reminder/medicine_reminder_provider.dart';
import 'widgets/medicine_reminder_card.dart';
import 'widgets/medicine_reminder_header.dart';
import 'widgets/medicine_reminder_save_button.dart';
import 'widgets/medicine_reminder_title.dart';
import 'widgets/medicine_reminder_top_icon.dart';

class MedicineReminderPage extends ConsumerStatefulWidget {
  const MedicineReminderPage({super.key});

  @override
  ConsumerState<MedicineReminderPage> createState() =>
      _MedicineReminderPageState();
}

class _MedicineReminderPageState extends ConsumerState<MedicineReminderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialData = ref.read(medicineFlowProvider).toMap();
      ref.read(medicineReminderProvider.notifier).init(initialData);
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
