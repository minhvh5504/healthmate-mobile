import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

import '../../theme/app_colors.dart';

class HeaderWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final bool showBack;
  final bool showMore;
  final bool showTitle;

  const HeaderWithBack({
    super.key,
    this.title,
    this.onBack,
    this.onMore,
    this.showBack = true,
    this.showMore = true,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back icon
          if (showBack)
            InkWell(
              borderRadius: BorderRadius.circular(50.r),
              onTap: onBack,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.typoBlack,
                ),
              ),
            )
          else
            SizedBox(width: 44.w),

          // Title
          if (showTitle && title != null)
            Expanded(
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoBlack,
                ),
              ),
            )
          else
            const Spacer(),

          // More icon
          if (showMore)
            InkWell(
              borderRadius: BorderRadius.circular(50.r),
              onTap: onMore,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: const HeroIcon(
                  HeroIcons.ellipsisVertical,
                  style: HeroIconStyle.solid,
                  color: AppColors.typoBody,
                  size: 22,
                ),
              ),
            )
          else
            SizedBox(width: 44.w),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
