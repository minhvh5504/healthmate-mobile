import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/medicine/presentation/providers/medicine/medicine_provider.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineTabBar extends ConsumerWidget {
  const MedicineTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final MedicineTab selectedTab;
  final ValueChanged<MedicineTab> onTabSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

          _PrescriptionCard(onTap: () => context.push(AppRoutes.prescription)),
        ],
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.onTap});

  final VoidCallback onTap;

  static const Color _iconColor = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.typoWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppIcons.navigationList,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    _iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'medicine.prescription'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoBlack,
                  height: 1,
                ),
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
