import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../domain/entities/scan_task.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../../domain/entities/user_medication.dart';
import 'medicine_empty_state.dart';

class MedicineCabinetContent extends ConsumerStatefulWidget {
  const MedicineCabinetContent({super.key});

  @override
  ConsumerState<MedicineCabinetContent> createState() =>
      _MedicineCabinetContentState();
}

class _MedicineCabinetContentState
    extends ConsumerState<MedicineCabinetContent> {
  bool isDangDungExpanded = true;
  bool isDaDungExpanded = true;
  bool isScanTasksExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineProvider);
    final scanTasks = state.scanTasks;
    final activeMedications = state.activeMedications;
    final notifier = ref.read(medicineProvider.notifier);

    final dangDungList = activeMedications;
    final daDungList = state.inactiveMedications;

    final bool isEmpty =
        dangDungList.isEmpty && daDungList.isEmpty && scanTasks.isEmpty;

    if (isEmpty) {
      return Center(
        child: MedicineEmptyState(
          actionLabel: 'medicine.add_medicine.title'.tr(),
          actionIcon: LucideIcons.plusSquare,
          onActionPressed: notifier.onAddMedicine,
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      children: [
        Column(
          children: [
            _buildActionCard(
              iconPath: AppIcons.medicine,
              title: 'medicine.add_medicine.title'.tr(),
              onTap: notifier.onAddMedicine,
            ),
            SizedBox(height: 8.h),
          ],
        ),

        ...scanTasks.take(2).map((t) => _buildScanTaskCard(context, t)),

        if (scanTasks.length > 2) ...[
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isScanTasksExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: scanTasks.skip(2).map((t) {
                        return _buildScanTaskCard(context, t)
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .slideY(begin: 0.1, end: 0, duration: 200.ms);
                      }).toList(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          _buildToggleExpandButton(
            isExpanded: isScanTasksExpanded,
            onTap: () {
              setState(() {
                isScanTasksExpanded = !isScanTasksExpanded;
              });
            },
          ),
          SizedBox(height: 8.h),
        ],

        if (dangDungList.isNotEmpty) ...[
          _buildSectionHeader(
            title: '${'medicine.in_use'.tr()} (${dangDungList.length})',
            isExpanded: isDangDungExpanded,
            onTap: () {
              setState(() {
                isDangDungExpanded = !isDangDungExpanded;
              });
            },
          ),
          ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isDangDungExpanded
                  ? Column(
                      key: const ValueKey('dangDung_expanded'),
                      mainAxisSize: MainAxisSize.min,
                      children: dangDungList
                          .map(
                            (m) => _buildActiveMedicationCard(
                              context,
                              m,
                              notifier,
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(key: ValueKey('dangDung_collapsed')),
            ),
          ),
        ],

        if (daDungList.isNotEmpty) ...[
          _buildSectionHeader(
            title: '${'medicine.used'.tr()} (${daDungList.length})',
            isExpanded: isDaDungExpanded,
            onTap: () {
              setState(() {
                isDaDungExpanded = !isDaDungExpanded;
              });
            },
          ),
          ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: isDaDungExpanded
                  ? Column(
                      key: const ValueKey('daDung_expanded'),
                      mainAxisSize: MainAxisSize.min,
                      children: daDungList
                          .map(
                            (m) => _buildActiveMedicationCard(
                              context,
                              m,
                              notifier,
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(key: ValueKey('daDung_collapsed')),
            ),
          ),
        ],
        SizedBox(height: 70.h),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.typoDisable, width: 1.8.w),
              ),
              child: Center(
                child: Icon(
                  isExpanded
                      ? LucideIcons.chevronDown
                      : LucideIcons.chevronRight,
                  size: 12.sp,
                  color: AppColors.typoDisable,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.typoHeading.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgPrimary, width: 2),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 24.w,
                height: 24.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.bgPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                  letterSpacing: 0,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.typoDisable,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanTaskCard(BuildContext context, ScanTask task) {
    Color iconColor;
    String iconPath;
    String title;
    String subtitle;

    switch (task.status) {
      case ScanStatus.processing:
        iconColor = const Color(0xFFF59E0B);
        iconPath = AppIcons.medicineBookWarn;
        title = 'medicine.scan_processing'.tr();
        subtitle = DateFormat('MMM d HH:mm').format(task.createdAt);
        break;
      case ScanStatus.success:
        iconColor = AppColors.bgSuccess;
        iconPath = AppIcons.medicine;
        title = 'medicine.scan_success'.tr();
        subtitle = 'medicine.tap_to_view'.tr();
        break;
      case ScanStatus.failed:
        iconColor = const Color(0xFFE94F56);
        iconPath = AppIcons.medicineBookError;
        title = 'medicine.scan_failed'.tr();
        subtitle = 'medicine.tap_to_retry'.tr();
        break;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          if (task.status == ScanStatus.processing) return;
          context.push(AppRoutes.reviewScan, extra: task.id);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 2),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w800,
                        color: task.status == ScanStatus.failed
                            ? iconColor
                            : AppColors.typoBlack,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: task.status == ScanStatus.failed
                            ? AppColors.typoBlack
                            : AppColors.typoBody.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: AppColors.typoDisable,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _frequencyLabel(UserMedication medication) {
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

  Widget _buildActiveMedicationCard(
    BuildContext context,
    UserMedication medication,
    MedicineNotifier notifier,
  ) {
    final hasNoStock = (medication.stockCount ?? 0) == 0;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppIcons.medicineLight,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.effectiveName.toUpperCase() != '-'
                          ? medication.effectiveName.toUpperCase()
                          : 'medicine.no_name'.tr(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBlack,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _frequencyLabel(medication),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBody.withValues(alpha: 0.72),
                      ),
                    ),

                    Text(
                      'medicine.stock_remaining'.tr(
                        args: [(medication.stockCount ?? 0).toString()],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: hasNoStock
                            ? const Color(0xFFD97706)
                            : AppColors.typoBody.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: medication.isActive
                      ? () =>
                            notifier.onShowMedicineOptions(context, medication)
                      : () => notifier.onShowDeleteConfirmDialog(
                          context,
                          medication,
                        ),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromHeight(48.h),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    side: BorderSide(
                      color: medication.isActive
                          ? AppColors.typoDisable.withValues(alpha: 0.28)
                          : AppColors.typoError.withValues(alpha: 0.5),
                      width: 1.5.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    medication.isActive
                        ? 'medicine.edit'.tr()
                        : 'medicine.delete'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: medication.isActive
                          ? AppColors.typoBlack
                          : AppColors.typoError,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: medication.isActive
                      ? () => notifier.onShowQuantityPopup(context, medication)
                      : () => notifier.onReactivateMedication(medication),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.typoBlack,
                    foregroundColor: Colors.white,
                    fixedSize: Size.fromHeight(48.h),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    medication.isActive
                        ? 'medicine.add_stock'.tr()
                        : 'medicine.activate'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleExpandButton({
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.typoDisable.withValues(alpha: 0.28),
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpanded
                    ? 'medicine.scan.collapse'.tr()
                    : 'medicine.scan.show_all'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                size: 16.sp,
                color: AppColors.typoBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
