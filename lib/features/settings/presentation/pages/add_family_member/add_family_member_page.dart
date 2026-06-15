import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/profile_header.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/add_family_member/add_family_member_provider.dart';
import '../../providers/family_connection/family_connection_provider.dart';

/// Screen for adding or connecting a family member.
class AddFamilyMemberPage extends ConsumerWidget {
  const AddFamilyMemberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const maxFamilyMembers = 5;
    final state = ref.watch(addFamilyMemberProvider);
    final familyState = ref.watch(familyConnectionProvider);
    final notifier = ref.read(addFamilyMemberProvider.notifier);
    final familyMemberCount = (familyState.members ?? [])
        .where((member) => member.status != 'revoked')
        .length
        .clamp(0, maxFamilyMembers);
    final hasReachedLimit = familyMemberCount >= maxFamilyMembers;

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
                onBack: () => notifier.onBack(),
                title: 'add_family.title'.tr(),
                subtitle: 'add_family.subtitle'.tr(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      InputTextField(
                        controller: state.emailController,
                        label: 'add_family.email_label'.tr(),
                        hint: 'add_family.email_hint'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        hasError: state.errorMessage != null,
                        errorText: state.errorMessage,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Button(
                      text: 'add_family.button_submit'.tr(),
                      onPressed: state.isLoading || hasReachedLimit
                          ? null
                          : () => notifier.onConnect(),
                      color: AppColors.typoBlack,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'add_family.footer_text'.tr(
                        args: [
                          familyMemberCount.toString(),
                          maxFamilyMembers.toString(),
                        ],
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        color: AppColors.typoBody.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}
