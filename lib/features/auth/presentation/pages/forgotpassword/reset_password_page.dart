import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/forgotpassword/reset_password_provider.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordNotifierProvider);
    final notifier = ref.read(resetPasswordNotifierProvider.notifier);

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
                // Back Button
                HeaderWithBack(
                  showBack: true,
                  showMore: false,
                  showTitle: false,
                  onBack: () => notifier.onPressBack(context),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 32.h),

                        // Title
                        Text(
                          'reset_password.title'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.typoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        // Subtitle
                        Text(
                          'reset_password.subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.typoBody,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // New password field
                        InputTextField(
                          controller: state.newPasswordController,
                          label: 'reset_password.new_password_label'.tr(),
                          hint: '********',
                          isPassword: true,
                          hasError: state.hasNewPassError,
                          errorText: notifier.passwordErrorText,
                        ),

                        SizedBox(height: 16.h),

                        // Confirm password field
                        InputTextField(
                          controller: state.confirmPasswordController,
                          label: 'reset_password.confirm_new_password_label'
                              .tr(),
                          hint: '********',
                          isPassword: true,
                          hasError: state.hasConfirmPassError,
                          errorText: notifier.confirmPasswordErrorText,
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                state.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 28.w,
                          height: 28.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.lightBlue,
                          ),
                        ),
                      )
                    : Button(
                        text: 'reset_password.button_submit'.tr(),
                        onPressed: state.isValid
                            ? () => notifier.onSubmit(context)
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
