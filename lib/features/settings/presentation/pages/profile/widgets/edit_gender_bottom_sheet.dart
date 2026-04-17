import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'base_profile_popup.dart';

class EditGenderBottomSheet extends StatefulWidget {
  final String? initialValue;
  final Function(String) onSave;

  const EditGenderBottomSheet({
    super.key,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<EditGenderBottomSheet> createState() => _EditGenderBottomSheetState();
}

class _EditGenderBottomSheetState extends State<EditGenderBottomSheet> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialValue?.toLowerCase() ?? 'male';
  }

  @override
  Widget build(BuildContext context) {
    return BaseProfilePopup(
      title: 'profile.gender'.tr(),
      onSave: () => widget.onSave(_selectedGender),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          children: [
            Expanded(
              child: _GenderCard(
                label: 'profile.female'.tr(),
                icon: Icons.female_rounded,
                isSelected: _selectedGender == 'female',
                onTap: () => setState(() => _selectedGender = 'female'),
                primaryColor: AppColors.lightPurple,
                iconColor: AppColors.typoError,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _GenderCard(
                label: 'profile.male'.tr(),
                icon: Icons.male_rounded,
                isSelected: _selectedGender == 'male',
                onTap: () => setState(() => _selectedGender = 'male'),
                primaryColor: AppColors.lightPurple,
                iconColor: AppColors.typoError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color? iconColor;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayIconColor = iconColor ?? primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.bgHover,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.sp,
              color: isSelected ? Colors.white : displayIconColor,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.typoBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
