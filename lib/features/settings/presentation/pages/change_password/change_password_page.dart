// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/change_password/change_password_provider.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordNotifierProvider);
    final notifier = ref.read(changePasswordNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Header with Back Button
                HeaderWithBack(
                  showBack: true,
                  showMore: false,
                  showTitle: false,
                  onBack: () => notifier.onBack(),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.h),

                        // Title
                        Text(
                          'high_settings.change_password'.tr(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.typoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Subtitle
                        Text(
                          'high_settings.change_password_subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.typoBody,
                          ),
                        ),

                        SizedBox(height: 36.h),

                        // Current Password
                        InputTextField(
                          controller: state.currentPasswordController,
                          label: 'change_password.current_password_label'.tr(),
                          hint: '********',
                          isPassword: true,
                          hasError: state.hasCurrentPasswordError,
                          errorText: notifier.currentPasswordErrorText,
                        ),

                        SizedBox(height: 20.h),

                        // New Password
                        InputTextField(
                          controller: state.newPasswordController,
                          label: 'change_password.new_password_label'.tr(),
                          hint: '********',
                          isPassword: true,
                          hasError: state.hasNewPasswordError,
                          errorText: notifier.newPasswordErrorText,
                        ),

                        SizedBox(height: 20.h),

                        // Confirm Password
                        InputTextField(
                          controller: state.confirmPasswordController,
                          label: 'change_password.confirm_password_label'.tr(),
                          hint: '********',
                          isPassword: true,
                          hasError: state.hasConfirmPasswordError,
                          errorText: notifier.confirmPasswordErrorText,
                        ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Update Button
                state.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 28.w,
                          height: 28.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.bgPrimary,
                          ),
                        ),
                      )
                    : Button(
                        text: 'high_settings.update'.tr(),
                        onPressed: state.isValid
                            ? () => notifier.onChangePassword(context)
                            : null,
                      ),

                SizedBox(height: 36.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
