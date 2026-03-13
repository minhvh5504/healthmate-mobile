import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/onboarding/onboarding_provider.dart';
import '../widgets/onboarding_item.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final state = ref.watch(onboardingNotifierProvider);

    final List<Map<String, String>> data = [
      {
        'title': 'onboarding.page1.title'.tr(),
        'image': 'assets/images/onboarding/onboard.png',
        'buttonText': 'onboarding.button_start'.tr(),
      },
      {
        'title': 'onboarding.page2.title'.tr(),
        'image': 'assets/images/onboarding/onboard.png',
        'buttonText': 'onboarding.button_start'.tr(),
      },
      {
        'title': 'onboarding.page3.title'.tr(),
        'image': 'assets/images/onboarding/onboard.png',
        'buttonText': 'onboarding.button_start'.tr(),
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => notifier.onUserInteraction(data.length),
            onPanDown: (_) => notifier.onUserInteraction(data.length),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                notifier.onUserInteraction(data.length);
                return false;
              },
              child: Column(
                children: [
                  Expanded(
                    child: OnBoardingItem(
                      titles: data.map((item) => item['title']!).toList(),
                      image: data.first['image']!,
                      buttonText: data.first['buttonText']!,
                      controller: notifier.controller,
                      currentIndex: state.currentIndex,
                      onPageChanged: (index) =>
                          notifier.onPageChanged(index, data.length),
                      onNext: () => notifier.nextPage(context, data.length),
                      onLogin: () => notifier.handleLogin(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
