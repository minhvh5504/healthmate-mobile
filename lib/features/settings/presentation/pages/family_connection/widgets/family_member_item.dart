import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/family_connection.dart';

/// Item widget displaying a [FamilyMember] row.
class FamilyMemberItem extends StatelessWidget {
  const FamilyMemberItem({
    super.key,
    required this.member,
    this.onTap,
    this.onRemove,
    this.isRemoving = false,
  });

  final FamilyMember member;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isRemoving;

  @override
  Widget build(BuildContext context) {
    final isPending = member.status == 'pending';

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
            SizedBox(width: 8.w),
            if (isPending) ...[
              Tooltip(
                message: 'family_connection.status_pending'.tr(),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgWarning.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.bgWarning.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    size: 17.sp,
                    color: AppColors.bgWarning,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Tooltip(
              message: isPending
                  ? 'family_connection.remove_pending_tooltip'.tr()
                  : 'family_connection.remove_connection_tooltip'.tr(),
              child: SizedBox(
                width: 34.w,
                height: 34.w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(34.w, 34.w)),
                  onPressed: isRemoving ? null : onRemove,
                  icon: isRemoving
                      ? SizedBox(
                          width: 17.w,
                          height: 17.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: AppColors.bgError,
                          ),
                        )
                      : Icon(
                          Icons.cancel_rounded,
                          size: 24.sp,
                          color: AppColors.bgError,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
