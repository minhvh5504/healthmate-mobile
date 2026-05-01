import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/medicine/presentation/providers/medicine/medicine_provider.dart';
import '../../../../../../core/providers/user_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/routing/app_router.dart';
import '../../../../../../core/routing/app_routes.dart';

class FamilySelectionBottomSheet extends ConsumerWidget {
  const FamilySelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final medicineState = ref.watch(medicineProvider);
    final medicineNotifier = ref.read(medicineProvider.notifier);

    final acceptedMembers = medicineState.familyMembers
        .where((m) => m.status == 'accepted')
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'medicine.family_popup.title'.tr(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoHeading,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'medicine.family_popup.subtitle'.tr(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              color: AppColors.typoBody,
            ),
          ),
          SizedBox(height: 32.h),

          // Me item
          _MemberItem(
            name:
                '${userProfile?.fullName ?? "Me"} (${"medicine.family_popup.me".tr()})',
            avatarUrl: userProfile?.avatarUrl,
            isSelected: medicineState.selectedFamilyMemberId == null,
            onTap: () => medicineNotifier.onSelectFamilyMember(context, null),
          ),
          SizedBox(height: 16.h),

          // Family members
          ...acceptedMembers.map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _MemberItem(
                name: member.name,
                avatarUrl: member.avatar,
                isSelected:
                    medicineState.selectedFamilyMemberId == member.userId,
                onTap: () => medicineNotifier.onSelectFamilyMember(
                  context,
                  member.userId,
                ),
              ),
            ),
          ),

          // Add supporter button
          _AddSupporterButton(
            onTap: () {
              Navigator.pop(context);
              AppRouter.router.push(AppRoutes.addFamilyMember);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _MemberItem extends StatelessWidget {
  const _MemberItem({
    required this.name,
    this.avatarUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String? avatarUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.bgPrimary
                : AppColors.typoDisable.withValues(alpha: 0.3),
            width: 1.5.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.bgPrimary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: avatarUrl != null
                      ? NetworkImage(avatarUrl!) as ImageProvider
                      : const AssetImage('assets/images/user/avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.bgPrimary
                      : AppColors.typoHeading,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.bgPrimary, size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class _AddSupporterButton extends StatelessWidget {
  const _AddSupporterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.typoDisable.withValues(alpha: 0.3),
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.typoDisable.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add_alt_1_outlined,
                color: AppColors.typoHeading,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'medicine.family_popup.add_supporter'.tr(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
