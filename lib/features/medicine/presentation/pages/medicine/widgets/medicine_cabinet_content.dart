import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  bool isDaDungExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineProvider);
    final scanTasks = state.scanTasks;
    final activeMedications = state.activeMedications;
    final notifier = ref.read(medicineProvider.notifier);

    // Filter lists
    final dangDungList = activeMedications.where((m) {
      final stock = m.stockCount ?? 30;
      return stock > 0;
    }).toList();

    final daDungList = activeMedications.where((m) {
      final stock = m.stockCount ?? 30;
      return stock == 0;
    }).toList();

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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        Column(
          children: [
            _buildActionCard(
              iconPath: AppIcons.medicine,
              title: 'medicine.add_medicine.title'.tr(),
              onTap: notifier.onAddMedicine,
            ),
            SizedBox(height: 16.h),
          ],
        ),

        ...scanTasks.map((t) => _buildScanTaskCard(context, t)),

        if (dangDungList.isNotEmpty)
          _buildSectionHeader(
            title: '${'medicine.in_use'.tr()} (${dangDungList.length})',
            isExpanded: isDangDungExpanded,
            onTap: () {
              setState(() {
                isDangDungExpanded = !isDangDungExpanded;
              });
            },
          ),
        if (isDangDungExpanded)
          ...dangDungList.map(
            (m) => _buildActiveMedicationCard(context, m, notifier),
          ),

        if (daDungList.isNotEmpty)
          _buildSectionHeader(
            title: '${'medicine.used'.tr()} (${daDungList.length})',
            isExpanded: isDaDungExpanded,
            onTap: () {
              setState(() {
                isDaDungExpanded = !isDaDungExpanded;
              });
            },
          ),
        if (isDaDungExpanded)
          ...daDungList.map(
            (m) => _buildActiveMedicationCard(context, m, notifier),
          ),
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
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        child: Row(
          children: [
            Icon(
              isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
              size: 20.sp,
              color: AppColors.typoHeading,
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                  fontSize: 16.sp,
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
              size: 24.sp,
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
      padding: EdgeInsets.only(bottom: 16.h),
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
                            ? AppColors.typoHeading
                            : AppColors.typoBody.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: AppColors.typoDisable,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveMedicationCard(
    BuildContext context,
    UserMedication medication,
    MedicineNotifier notifier,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
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
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppIcons.medicineLight,
                  width: 30.w,
                  height: 30.w,
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
                        fontWeight: FontWeight.w800,
                        color: AppColors.typoBlack,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      medication.medication?.genericName ??
                          'medicine.daily'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBody.withValues(alpha: 0.72),
                      ),
                    ),

                    Text(
                      'medicine.stock_remaining'.tr(
                        args: [(medication.stockCount ?? 30).toString()],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoBody.withValues(alpha: 0.72),
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
                  onPressed: () =>
                      notifier.onShowMedicineOptions(context, medication),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: AppColors.typoDisable.withValues(alpha: 0.28),
                      width: 1.5.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'medicine.edit'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      notifier.onShowQuantityPopup(context, medication),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.typoBlack,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'medicine.add_stock'.tr(),
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
}
