import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/medicine/presentation/providers/medicine/medicine_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/daily_schedule_item.dart';

class MedicineLoggedPopup extends ConsumerWidget {
  final DailyScheduleItem item;

  const MedicineLoggedPopup({super.key, required this.item});

  static void show(BuildContext context, DailyScheduleItem item) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Logged Popup',
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
                  child: MedicineLoggedPopup(item: item),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final status = item.status.toLowerCase();
    final isTaken = status == 'taken';

    final statusColor = isTaken
        ? const Color(0xFF6B66FF)
        : const Color(0xFFF04438);
    final actionIcon = isTaken ? LucideIcons.x : LucideIcons.check;
    final actionIconColor = isTaken
        ? const Color(0xFFF04438)
        : AppColors.typoBlack;
    final actionLabel = isTaken ? 'Đổi thành đã bỏ lỡ' : 'Đổi thành đã uống';

    String statusText = '';
    final instruction = _getMealInstructionText(
      context,
      item.mealInstruction,
    ).toUpperCase();
    if (isTaken) {
      statusText = 'ĐÃ UỐNG ${item.dosage ?? 1} LẦN $instruction';
    } else {
      statusText = 'BỎ LỠ ${item.dosage ?? 1} LẦN $instruction';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                LucideIcons.x,
                color: AppColors.typoBlack.withValues(alpha: 0.4),
                size: 24.sp,
              ),
            ),
          ),

          // Icon Circle
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              color: Color(0xFF535874),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                LucideIcons.moreHorizontal,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Medication Name
          Text(
            item.medicationName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.typoBlack,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          // Status Label
          Text(
            statusText,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: statusColor.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32.h),

          // Action Button
          GestureDetector(
            onTap: () {
              ref.read(medicineProvider.notifier).onChangeStatus(item);
              context.pop();
            },
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.typoDisable.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      actionIcon,
                      color: actionIconColor,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  actionLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.typoBlack,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  String _getMealInstructionText(BuildContext context, String? slug) {
    if (slug == null || slug.isEmpty) return '';
    final key = 'medicine.instruction.$slug';
    final translated = key.tr();
    return translated == key ? slug : translated;
  }
}
