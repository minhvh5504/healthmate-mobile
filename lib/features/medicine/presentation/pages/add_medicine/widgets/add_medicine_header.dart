import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';

class AddMedicineHeader extends StatelessWidget {
  const AddMedicineHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 24.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoBlack,
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Icon(
              LucideIcons.x,
              color: AppColors.typoDisable,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
