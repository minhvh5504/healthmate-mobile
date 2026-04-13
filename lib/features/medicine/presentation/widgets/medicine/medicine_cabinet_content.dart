import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/scan_task.dart';
import '../../providers/medicine/medicine_provider.dart';
import '../../../domain/entities/user_medication.dart';

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
      final stockRaw = m.scannedData?['stock'] ?? 30;
      final stock = int.tryParse(stockRaw.toString()) ?? 30;
      return stock > 0;
    }).toList();

    final daDungList = activeMedications.where((m) {
      final stockRaw = m.scannedData?['stock'] ?? 30;
      final stock = int.tryParse(stockRaw.toString()) ?? 30;
      return stock == 0;
    }).toList();

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      children: [
        Column(
          children: [
            _buildActionCard(
              icon: LucideIcons.pill,
              iconColor: AppColors.bgPrimary,
              title: 'medicine.add_medicine.title'.tr(),
              onTap: notifier.onAddMedicine,
            ),
            SizedBox(height: 16.h),
          ],
        ),

        ...scanTasks.map((t) => _buildScanTaskCard(context, t)),

        if (dangDungList.isNotEmpty)
          _buildSectionHeader(
            title: 'Đang dùng (${dangDungList.length})',
            isExpanded: isDangDungExpanded,
            onTap: () {
              setState(() {
                isDangDungExpanded = !isDangDungExpanded;
              });
            },
          ),
        if (isDangDungExpanded)
          ...dangDungList.map((m) => _buildActiveMedicationCard(context, m)),

        if (daDungList.isNotEmpty)
          _buildSectionHeader(
            title: 'Đã dùng (${daDungList.length})',
            isExpanded: isDaDungExpanded,
            onTap: () {
              setState(() {
                isDaDungExpanded = !isDaDungExpanded;
              });
            },
          ),
        if (isDaDungExpanded)
          ...daDungList.map((m) => _buildActiveMedicationCard(context, m)),
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
                color: AppColors.typoHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoHeading,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.typoBody.withValues(alpha: 0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanTaskCard(BuildContext context, ScanTask task) {
    Color iconColor;
    IconData iconData;
    String title;
    String subtitle;

    switch (task.status) {
      case ScanStatus.processing:
        iconColor = Colors.orange;
        iconData = LucideIcons.fileText;
        title = 'medicine.scan_processing'.tr();
        subtitle = DateFormat('MMM d HH:mm').format(task.createdAt);
        break;
      case ScanStatus.success:
        iconColor = Colors.green;
        iconData = LucideIcons.checkCircle;
        title = 'medicine.scan_success'.tr();
        subtitle = 'medicine.tap_to_view'.tr();
        break;
      case ScanStatus.failed:
        iconColor = Colors.red;
        iconData = LucideIcons.fileWarning;
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor.withValues(alpha: 0.5)),
                ),
                child: Icon(iconData, color: iconColor, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: task.status == ScanStatus.failed
                            ? iconColor
                            : AppColors.typoHeading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
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
                color: AppColors.typoBody.withValues(alpha: 0.5),
                size: 20.sp,
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
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.pill,
                  color: AppColors.bgPrimary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.medication?.name.toUpperCase() ??
                          'KHÔNG RÕ TÊN',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.typoHeading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Hàng ngày',

                      /// Fallback/Placeholder
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        color: AppColors.typoBody.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      'Còn ${int.tryParse((medication.scannedData?['stock'] ?? 30).toString()) ?? 30} lần dùng',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        color: AppColors.typoBody.withValues(alpha: 0.6),
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
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: AppColors.typoBody.withValues(alpha: 0.1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'Sửa',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoHeading,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.typoHeading,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Bổ sung',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
