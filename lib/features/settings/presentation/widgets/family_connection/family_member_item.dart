import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_connection.dart';

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
              child: Text(
                member.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.typoBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
