import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile/profile_notifier.dart';
import '../providers/profile/profile_provider.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/info_row_tile.dart';
import '../widgets/profile/profile_error_banner.dart';
import '../widgets/profile/profile_skeleton.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(onBack: notifier.onBack),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'settings.profile_subtitle'.tr(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    color: AppColors.typoBody,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      if (state.isLoading && state.profile == null)
                        const ProfileSkeleton()
                      else ...[
                        // Embedded Info Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              InfoRowTile(
                                label: 'settings.full_name'.tr(),
                                value: state.profile?.fullName ?? '—',
                                onTap: notifier.onEditFullName,
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.gender'.tr(),
                                value: ProfileNotifier.formatGender(
                                  state.profile?.gender,
                                ),
                                onTap: notifier.onEditGender,
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.birthday'.tr(),
                                value: ProfileNotifier.formatDate(
                                  state.profile?.dateOfBirth,
                                ),
                                onTap: notifier.onEditBirthDate,
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.height'.tr(),
                                value: state.profile?.heightCm != null
                                    ? '${state.profile!.heightCm} cm'
                                    : '—',
                                onTap: notifier.onEditHeight,
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.weight'.tr(),
                                value: state.profile?.weightKg != null
                                    ? '${state.profile!.weightKg} kg'
                                    : '—',
                                onTap: notifier.onEditWeight,
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.email'.tr(),
                                value: state.profile?.email ?? '—',
                                onTap: notifier.onEditEmail,
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 16.h),
                      if (state.errorMessage != null)
                        ProfileErrorBanner(
                          message: state.errorMessage!,
                          onRetry: notifier.loadProfile,
                        ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
