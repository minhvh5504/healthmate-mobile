import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/profile/profile_notifier.dart';
import '../../providers/profile/profile_provider.dart';
import '../../../../../core/widgets/header/profile_header.dart';
import 'widgets/info_row_tile.dart';
import 'widgets/profile_skeleton.dart';

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
              ProfileHeader(
                onBack: notifier.onBack,
                title: 'settings.basic_info'.tr(),
                subtitle: 'settings.profile_subtitle'.tr(),
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
                                color: Colors.black.withValues(alpha: 0.06),
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
                                onTap: () => notifier.onEditFullName(context),
                              ),

                              const InfoRowDivider(),

                              InfoRowTile(
                                label: 'settings.email'.tr(),
                                value: state.profile?.email ?? '—',
                              ),

                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.gender'.tr(),
                                value: ProfileNotifier.formatGender(
                                  state.profile?.gender,
                                ),
                                onTap: () => notifier.onEditGender(context),
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.birthday'.tr(),
                                value: ProfileNotifier.formatDate(
                                  state.profile?.dateOfBirth,
                                ),
                                onTap: () => notifier.onEditBirthDate(context),
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.height'.tr(),
                                value: state.profile?.heightCm != null
                                    ? '${state.profile!.heightCm} cm'
                                    : '—',
                              ),
                              const InfoRowDivider(),
                              InfoRowTile(
                                label: 'settings.weight'.tr(),
                                value: state.profile?.weightKg != null
                                    ? '${state.profile!.weightKg} kg'
                                    : '—',
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 16.h),
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
