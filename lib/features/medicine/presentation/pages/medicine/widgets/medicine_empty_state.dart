import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineEmptyState extends StatelessWidget {
  const MedicineEmptyState({
    super.key,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon = LucideIcons.package,
  });

  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _MedicineIllustration(),
            SizedBox(height: 16.h),
            Text(
              'medicine.empty_body'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBody,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              SizedBox(height: 24.h),
              Button(
                height: 50.h,
                icon: Icon(actionIcon, size: 24.sp, color: Colors.white),
                text: actionLabel!,
                onPressed: onActionPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MedicineIllustration extends StatelessWidget {
  const _MedicineIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.notFound,
      width: 180.w,
      height: 180.w,
      fit: BoxFit.contain,
    );
  }
}
