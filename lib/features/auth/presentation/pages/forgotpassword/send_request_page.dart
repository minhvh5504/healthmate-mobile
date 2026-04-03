import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/forgotpassword/send_request_provider.dart';

class SendRequestPage extends ConsumerWidget {
  const SendRequestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sendRequestNotifierProvider);
    final notifier = ref.read(sendRequestNotifierProvider.notifier);

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
                          'forgot_password.title'.tr(),
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.typoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        // Subtitle
                        Text(
                          'forgot_password.subtitle'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.typoBody,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Email
                        InputTextField(
                          controller: state.emailController,
                          label: 'forgot_password.email_label'.tr(),
                          hint: 'forgot_password.email_hint'.tr(),
                          hasError: state.hasEmailError,
                          errorText: notifier.emailErrorText,
                          keyboardType: TextInputType.emailAddress,
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
                        text: 'forgot_password.button_send'.tr(),
                        onPressed: state.isValid
                            ? () => notifier.onSendCode(context)
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
