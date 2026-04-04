import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/header/profile_header.dart';
import '../providers/family_connection/family_connection_notifier.dart';
import '../providers/family_connection/family_connection_provider.dart';
import '../widgets/family_connection/family_connection_skeleton.dart';
import '../widgets/family_connection/family_member_item.dart';

/// Screen for managing family connections.
class FamilyConnectionPage extends ConsumerWidget {
  const FamilyConnectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyConnectionProvider);
    final notifier = ref.read(familyConnectionProvider.notifier);

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
                title: 'family_connection.title'.tr(),
                subtitle: 'family_connection.subtitle'.tr(),
              ),
              Expanded(
                child: state.isLoading && state.members == null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: const FamilyConnectionSkeleton(),
                      )
                    : _buildContent(context, state, notifier),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Button(
                  icon: Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                  text: 'family_connection.button_add'.tr(),
                  onPressed: () => notifier.onAddMember(),
                ),
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    FamilyConnectionState state,
    FamilyConnectionNotifier notifier,
  ) {
    final members = state.members ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          if (members.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                return FamilyMemberItem(
                  member: members[index],
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
