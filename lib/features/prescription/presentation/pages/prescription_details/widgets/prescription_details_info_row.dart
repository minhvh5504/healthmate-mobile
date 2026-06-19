import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/theme/app_colors.dart';

class PrescriptionDetailsInfoRow extends StatelessWidget {
  const PrescriptionDetailsInfoRow({
    super.key,
    this.icon,
    this.iconAsset,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData? icon;
  final String? iconAsset;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoIcon(icon: icon, asset: iconAsset),
          SizedBox(width: 12.w),
          Expanded(
            flex: 5,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 7,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.typoBody.withValues(alpha: 0.8),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({this.icon, this.asset});

  final IconData? icon;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF72799B);
    final size = 16.sp;

    if (asset != null) {
      return SvgPicture.asset(
        asset!,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    if (icon != null) {
      return Icon(icon, size: size, color: color);
    }

    return SizedBox(width: size);
  }
}
