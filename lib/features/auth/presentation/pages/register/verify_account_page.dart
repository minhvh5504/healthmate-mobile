// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../providers/register/verify_account_provider.dart';
import '../../providers/register/verify_account_notifier.dart';

class VerifyAccountPage extends ConsumerStatefulWidget {
  const VerifyAccountPage({super.key});

  @override
  ConsumerState<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends ConsumerState<VerifyAccountPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyAccountNotifierProvider);
    final notifier = ref.read(verifyAccountNotifierProvider.notifier);

    // Clear pin when error timer expires
    ref.listen<VerifyAccountState>(verifyAccountNotifierProvider, (prev, next) {
      if (prev != null &&
          prev.remainingSeconds > 0 &&
          next.remainingSeconds == 0 &&
          prev.errorMessage != null) {
        _pinController.clear();
      }
    });

    // Pin default
    final defaultPinTheme = PinTheme(
      width: 44.w,
      height: 44.h,
      textStyle: TextStyle(fontFamily: 'Inter',
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.typoHeading.withOpacity(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.5),
        border: Border.all(color: AppColors.bgDisable.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    // Pin focused
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.typoHeading.withOpacity(0.5),
          width: 2.0,
        ),
        color: AppColors.white,
      ),
    );

    // Pin submitted
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.white.withOpacity(0.8),
        border: Border.all(color: AppColors.bgDisable.withOpacity(0.2)),
      ),
    );

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
                          'verify_account.title'.tr(),
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.typoBlack,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        // Subtitle
                        Text(
                          'verify_account.subtitle'.tr(),
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.typoBody,
                          ),
                        ),

                        // Email
                        Text(
                          state.email,
                          style: TextStyle(fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.typoHeading,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // OTP input
                        Pinput(
                          controller: _pinController,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          keyboardType: TextInputType.number,
                          onCompleted: notifier.onCodeCompleted,
                          onChanged: (val) => notifier.onCodeChanged(val),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          autofocus: true,
                          preFilledWidget: Text(
                            '-',
                            style: TextStyle(fontFamily: 'Inter',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bgDisable.withOpacity(0.5),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Status Capsule
                        _buildStatusNote(context, state, notifier),

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
                        text: 'verify_account.button_verify'.tr(),
                        onPressed: (state.isValid && !state.isResending)
                            ? () => notifier.onVerify(context)
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

  /// Build status note
  Widget _buildStatusNote(
    BuildContext context,
    VerifyAccountState state,
    VerifyAccountNotifier notifier,
  ) {
    final bool hasError =
        state.errorMessage != null && state.remainingSeconds > 0;
    final bool isCountdown = state.resendSeconds > 0;

    if (hasError) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFA),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: AppColors.bgError.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              color: AppColors.typoError,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              state.errorMessage!,
              style: TextStyle(fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoError,
              ),
            ),
          ],
        ),
      );
    }

    // Countdown or Resend Note
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.bgDisable.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: AppColors.typoBody, size: 18.sp),
          SizedBox(width: 4.w),
          Text(
            '${'verify_account.question_not_receive'.tr()} ',
            style: TextStyle(fontFamily: 'Inter',
              fontSize: 12.sp,
              color: AppColors.typoBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isCountdown)
            Text(
              notifier.formatTime(state.resendSeconds),
              style: TextStyle(fontFamily: 'Inter',
                fontSize: 12.sp,
                color: AppColors.typoBlack,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            InkWell(
              onTap: state.isResending
                  ? null
                  : () {
                      _pinController.clear();
                      notifier.onResend(context);
                    },
              child: Text(
                'verify_account.resend'.tr(),
                style: TextStyle(fontFamily: 'Inter',
                  fontSize: 14.sp,
                  color: AppColors.typoHeading,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
