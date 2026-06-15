import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../providers/medicine_stock/medicine_stock_notifier.dart';
import '../../../providers/medicine_stock/medicine_stock_provider.dart';
import 'medicine_low_stock_popup.dart';
import 'medicine_stock_count_popup.dart';
import 'medicine_stock_item.dart';

class MedicineStockCard extends ConsumerWidget {
  const MedicineStockCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineStockProvider);
    final notifier = ref.read(medicineStockProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
          MedicineStockItem(
            icon: AppIcons.medicineDictionary,
            title: 'medicine.stock.item_title_remaining'.tr(),
            subtitle: 'medicine.stock.remaining_times'.tr(
              args: [state.stockCount.toString()],
            ),
            subtitleColor: state.stockCount == 0
                ? const Color(0xFFD97706)
                : null,
            onTap: () =>
                _showStockCountPopup(context, notifier, state.stockCount),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(
              color: AppColors.typoBody.withValues(alpha: 0.05),
              thickness: 1,
            ),
          ),
          MedicineStockItem(
            icon: AppIcons.medicineClock,
            title: 'medicine.stock.item_title_reminder'.tr(),
            subtitle: state.lowStockReminderEnabled
                ? 'medicine.stock.remaining_times'.tr(
                    args: [state.lowStockThreshold.toString()],
                  )
                : 'medicine.stock.reminder_off'.tr(),
            onTap: () => _showLowStockPopup(
              context,
              notifier,
              state.lowStockReminderEnabled,
              state.lowStockThreshold,
            ),
          ),
        ],
      ),
    );
  }

  void _showStockCountPopup(
    BuildContext context,
    MedicineStockNotifier notifier,
    int initialCount,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Stock Count',
      barrierColor: Colors.black.withValues(alpha: 0.2),
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
                child: MedicineStockCountPopup(
                  initialCount: initialCount,
                  onSave: notifier.updateStockCount,
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _showLowStockPopup(
    BuildContext context,
    MedicineStockNotifier notifier,
    bool initialEnabled,
    int initialThreshold,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Low Stock Reminder',
      barrierColor: Colors.black.withValues(alpha: 0.2),
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
                child: MedicineLowStockPopup(
                  initialEnabled: initialEnabled,
                  initialThreshold: initialThreshold,
                  onSave: (enabled, threshold) {
                    notifier.toggleLowStockReminder(enabled);
                    notifier.updateLowStockThreshold(threshold);
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
