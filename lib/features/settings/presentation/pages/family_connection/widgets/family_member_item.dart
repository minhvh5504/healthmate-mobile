import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/family_connection.dart';

/// Item widget displaying a [FamilyMember] row.
class FamilyMemberItem extends StatelessWidget {
  const FamilyMemberItem({super.key, required this.member, this.onTap});

  final FamilyMember member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgHover,
                image: member.avatar != null
                    ? DecorationImage(
                        image: NetworkImage(member.avatar!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: member.avatar == null
                  ? Icon(Icons.person, size: 24.sp, color: AppColors.typoBody)
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoBlack,
                    ),
                  ),
                  Text(
                    member.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.typoBody,
                    ),
                  ),
                ],
              ),
            ),
            if (member.status == 'pending') ...[
              SizedBox(width: 8.w),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.bgWarning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.bgWarning.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14.sp,
                        color: AppColors.bgWarning,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'family_connection.status_pending'.tr(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bgWarning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
