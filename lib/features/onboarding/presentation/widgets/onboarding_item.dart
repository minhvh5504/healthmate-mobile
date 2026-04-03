import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/button/button.dart';

class OnBoardingItem extends StatelessWidget {
  final List<String> titles;
  final String image;
  final String buttonText;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onLogin;

  const OnBoardingItem({
    super.key,
    required this.titles,
    required this.image,
    required this.buttonText,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onNext,
    required this.onLogin,
  });

  @override
  /// Builds the onboarding content item.
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: Image.asset(image, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.backgroundGradient,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 0.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 132.h,
                            child: PageView.builder(
                              controller: controller,
                              onPageChanged: onPageChanged,
                              itemCount: titles.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  titles[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Inter',
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.typoBlack,
                                    height: 1.35,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              titles.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: currentIndex == index ? 24.w : 8.w,
                                height: 7.h,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? AppColors.typoBlack
                                      : AppColors.bgDisable,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 36.h),
                          SizedBox(
                            width: double.infinity,
                            child: Button(text: buttonText, onPressed: onNext),
                          ),
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              text: '${'onboarding.have_account'.tr()} ',
                              style: TextStyle(fontFamily: 'Inter',
                                color: AppColors.typoBody,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: 'onboarding.login'.tr(),
                                  style: TextStyle(fontFamily: 'Inter',
                                    color: AppColors.typoBlack,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.typoBlack,
                                    decorationThickness: 0.6,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = onLogin,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
