import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../domain/entities/user_medication.dart';
import '../../medicine_detail_preview/widgets/medicine_detail_item.dart';

class MedicineOptionsPopup extends StatelessWidget {
  final UserMedication medication;
  final VoidCallback? onEditDetails;
  final VoidCallback? onChangeSchedule;
  final VoidCallback? onAddMedicine;
  final VoidCallback? onDeleteAll;

  const MedicineOptionsPopup({
    super.key,
    required this.medication,
    this.onEditDetails,
    this.onChangeSchedule,
    this.onAddMedicine,
    this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    final stock = medication.stockCount ?? 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 16.h,
              right: 16.w,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  LucideIcons.x,
                  color: AppColors.typoBody.withValues(alpha: 0.4),
                  size: 24.sp,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      medication.effectiveName != '-'
                          ? medication.effectiveName
                          : 'medicine.no_name'.tr(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.typoBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Subtitle
                  Text(
                    'medicine.stock_remaining'.tr(args: [stock.toString()]),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Center Icon Container
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7A7EAC), AppColors.typoHeading],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          LucideIcons.moreHorizontal,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Label below icon
                  Text(
                    _frequencyLabel(medication),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.typoBody.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Options List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: AppColors.typoBody.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        MedicineDetailItem(
                          icon: AppIcons.medicine,
                          title: 'medicine.options_popup.edit_details'.tr(),
                          onTap: () {
                            context.pop();
                            onEditDetails?.call();
                          },
                        ),
                        _buildDivider(),
                        MedicineDetailItem(
                          icon: AppIcons.medicineClock,
                          title: 'medicine.options_popup.change_schedule'.tr(),
                          onTap: () {
                            context.pop();
                            onChangeSchedule?.call();
                          },
                        ),
                        _buildDivider(),
                        MedicineDetailItem(
                          icon: AppIcons.medicineDictionary,
                          title: 'medicine.options_popup.add_medicine'.tr(),
                          onTap: () {
                            context.pop();
                            onAddMedicine?.call();
                          },
                        ),
                        _buildDivider(),
                        MedicineDetailItem(
                          icon: AppIcons.stop,
                          title: 'medicine.options_popup.delete_all'.tr(),
                          titleColor: AppColors.bgError,
                          onTap: () {
                            context.pop();
                            onDeleteAll?.call();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.typoBody.withValues(alpha: 0.05),
      indent: 16.w,
      endIndent: 16.w,
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
}
