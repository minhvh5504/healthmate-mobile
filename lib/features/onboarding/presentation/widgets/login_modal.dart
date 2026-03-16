import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/button/button.dart';
import '../providers/onboarding/onboarding_provider.dart';

class LoginModal extends ConsumerWidget {
  final VoidCallback onContinueWithEmail;
  final VoidCallback onContinueWithGoogle;

  const LoginModal({
    super.key,
    required this.onContinueWithEmail,
    required this.onContinueWithGoogle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(onboardingNotifierProvider.select((s) => s.isLoading));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.bgHover,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 12.h),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              Text(
                'onboarding.login'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.typoBlack,
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppColors.typoBlack.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Continue with Email
          Button(
            text: 'login_modal.continue_with_email'.tr(),
            icon: Icon(Icons.email, color: AppColors.typoWhite, size: 20.sp),
            onPressed: onContinueWithEmail,
          ),
          SizedBox(height: 24.h),

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(color: AppColors.typoDisable.withOpacity(0.6)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'login_modal.or'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.typoDisable.withOpacity(0.8),
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: AppColors.typoDisable.withOpacity(0.6)),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Continue with Google
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.lightBlue),
              )
              : Button(
                text: 'login_modal.continue_with_google'.tr(),
                color: AppColors.bgWhite,
                textColor: AppColors.typoBlack,
                borderColor: Colors.grey[300],
                icon: SvgPicture.asset(
                  'assets/icons/auth/google.svg',
                  width: 20.w,
                  height: 20.h,
                ),
                onPressed: onContinueWithGoogle,
              ),
          SizedBox(height: 96.h),
        ],
      ),
    );
  }
}
