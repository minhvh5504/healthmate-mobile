// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/medicine/presentation/providers/medicine/medicine_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/daily_schedule_item.dart';
import '../../medicine_reminder_edit/widgets/medicine_reminder_time_popup.dart';

class MedicineSchedulePopup extends ConsumerStatefulWidget {
  final DailyScheduleItem item;
  final String instructionText;

  const MedicineSchedulePopup({
    super.key,
    required this.item,
    required this.instructionText,
  });

  static void show(
    BuildContext context,
    DailyScheduleItem item,
    String instructionText,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Schedule Popup',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: MedicineSchedulePopup(
                    item: item,
                    instructionText: instructionText,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  @override
  ConsumerState<MedicineSchedulePopup> createState() =>
      _MedicineSchedulePopupState();
}

class _MedicineSchedulePopupState extends ConsumerState<MedicineSchedulePopup> {
  late int _quantity;
  String? _remindTime;
  late String _instructionSlug;

  @override
  void initState() {
    super.initState();
    _quantity =
        widget.item.quantity ?? int.tryParse(widget.item.dosage ?? '1') ?? 1;
    _remindTime = widget.item.remindTime;
    _instructionSlug = widget.item.mealInstruction ?? 'before_breakfast';
  }

  void _updateMealInstructionByTime(String selectedTime) {
    setState(() {
      _remindTime = selectedTime;
      _instructionSlug = MedicineNotifier.getInstructionSlugFromTime(
        selectedTime,
      );
    });
  }

  String _getInstructionText() {
    return 'medicine.instruction.$_instructionSlug'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                LucideIcons.x,
                color: AppColors.typoBlack,
                size: 24.sp,
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Main Icon
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              color: Color(0xFF535874), // Dark slate blue
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 6.w,
                      height: 6.w,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB1B6C1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Medication Name
          Text(
            widget.item.medicationName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.typoBlack,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // Content Box
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.typoHeading.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'medicine.log_status.time'.tr(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final initial = _remindTime ?? '08:00';
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Time Picker',
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (ctx, anim1, anim2) {
                            return Scaffold(
                              backgroundColor: Colors.transparent,
                              body: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => ctx.pop(),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: AppColors.backgroundGradient,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: MedicineReminderTimePopup(
                                      initialTime: initial,
                                      onSave: (val) {
                                        ctx.pop();
                                        _updateMealInstructionByTime(val);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          transitionBuilder: (context, anim1, anim2, child) {
                            return FadeTransition(opacity: anim1, child: child);
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.typoDisable.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _getInstructionText(),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.typoBlack,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              LucideIcons.chevronRight,
                              size: 14.sp,
                              color: AppColors.typoBlack,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  color: AppColors.typoBlack.withValues(alpha: 0.15),
                ),
                SizedBox(height: 16.h),

                // Row 2: Dosage Controller
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      child: _buildCircleIconButton(LucideIcons.minus),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.typoDisable.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            '$_quantity',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.typoBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        setState(() => _quantity++);
                      },
                      child: _buildCircleIconButton(LucideIcons.plus),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'medicine.reminder.doses_count'.tr(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Bottom Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: LucideIcons.x,
                iconColor: const Color(0xFFF04438),
                bgColor: Colors.white,
                borderColor: AppColors.typoBlack.withValues(alpha: 0.2),
                label: 'medicine.log_status.action_missed'.tr(),
                onTap: () {
                  ref
                      .read(medicineProvider.notifier)
                      .onMissMedication(item: widget.item, quantity: _quantity);
                  context.pop();
                },
              ),
              SizedBox(width: 40.w),
              _buildActionButton(
                icon: LucideIcons.check,
                iconColor: Colors.white,
                bgColor: const Color(0xFF1E2135),
                borderColor: const Color(0xFF1E2135),
                label: 'medicine.log_status.action_taken'.tr(),
                onTap: () {
                  ref
                      .read(medicineProvider.notifier)
                      .onTakeMedication(
                        item: widget.item,
                        quantity: _quantity,
                        selectedTime: _remindTime,
                      );
                  context.pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.typoBlack.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: 20.sp, color: AppColors.typoBlack),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 32.sp, color: iconColor),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.typoBlack,
          ),
        ),
      ],
    );
  }
}
