import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: InkWell(
                      onTap: () => notifier.onBack(context),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: AppColors.typoBlack,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Illustration Card
                _buildIllustration(),

                SizedBox(height: 48.h),

                // Heading
                Text(
                  'Tạo tài khoản miễn phí\ncủa bạn',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
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
                    'Dữ liệu sức khỏe của bạn được bảo mật và phân tích chuyên sâu để mang lại kết quả tốt nhất.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
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
      text: 'Tiếp tục với email',
      icon: Icon(Icons.email_rounded, color: AppColors.typoWhite, size: 20.sp),
      onPressed: () => notifier.onContinueWithEmail(context),
    );
  }
}
