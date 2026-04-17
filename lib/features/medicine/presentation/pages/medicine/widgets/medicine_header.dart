import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine/medicine_notifier.dart';

class MedicineTabBar extends StatelessWidget {
  const MedicineTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.avatarUrl,
  });

  final MedicineTab selectedTab;
  final ValueChanged<MedicineTab> onTabSelected;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _TabItem(
            label: 'medicine.tab_schedule'.tr(),
            isSelected: selectedTab == MedicineTab.schedule,
            onTap: () => onTabSelected(MedicineTab.schedule),
          ),
          SizedBox(width: 8.w),
          _TabItem(
            label: 'medicine.tab_cabinet'.tr(),
            isSelected: selectedTab == MedicineTab.cabinet,
            onTap: () => onTabSelected(MedicineTab.cabinet),
          ),
          const Spacer(),

          /// User avatar + dropdown caret
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: avatarUrl != null
                        ? NetworkImage(avatarUrl!) as ImageProvider
                        : const AssetImage('assets/images/user/avatar.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: AppColors.typoBody,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.typoNavi : AppColors.typoBody,
              ),
            ),
            SizedBox(height: 6.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3.h,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.typoNaviButton
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
