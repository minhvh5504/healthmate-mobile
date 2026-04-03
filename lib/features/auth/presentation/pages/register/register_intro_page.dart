import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../providers/register/register_intro_provider.dart';

class RegisterIntroPage extends ConsumerWidget {
  const RegisterIntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(registerIntroNotifierProvider.notifier);

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
                  onBack: () => notifier.onBack(context),
                ),

                const Spacer(flex: 1),

                // Illustration Card
                _buildIllustration(),

                SizedBox(height: 48.h),

                // Heading
                Text(
                  'register_intro.title'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Inter',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.typoBlack,
                  ),
                ),

                SizedBox(height: 16.h),

                // Subheading
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'register_intro.subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.typoBody,
                      height: 1.6,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Continue with Email Button
                _buildEmailButton(context, notifier),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/auth/locker.svg',
        width: double.infinity,
        height: 240.w,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildEmailButton(BuildContext context, dynamic notifier) {
    return Button(
      text: 'register_intro.email_button'.tr(),
      icon: Icon(Icons.email_rounded, color: AppColors.typoWhite, size: 20.sp),
      onPressed: () => notifier.onContinueWithEmail(context),
    );
  }
}
