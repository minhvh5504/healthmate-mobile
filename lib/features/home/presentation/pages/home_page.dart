import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/health_status_section.dart';
import '../widgets/home_header.dart';
import '../widgets/shortcut_card.dart';

import '../providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              HomeHeader(
                onProfilePressed: homeNotifier.onProfile,
                onNotificationPressed: homeNotifier.onNotification,
                avatarUrl: homeState.profile?.avatarUrl,
              ),

              const SizedBox(height: 4),

              // White Card Body
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(16, 0),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section: Shortcuts
                        Text(
                          'home.shortcuts'.tr(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.typoBlack,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // AI Assistant card
                            HomeShortcutCard(
                              label: 'home.ai_assistant'.tr(),
                              onTap: homeNotifier.onAiAssistant,
                              backgroundColor: Colors.white,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE2E8F0), Color(0xFF93C5FD)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Image.asset(
                                'assets/icons/home/ai.png',
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(width: 8.w),

                            // Connect relative card
                            HomeShortcutCard(
                              label: 'home.connect_relative'.tr(),
                              onTap: homeNotifier.onConnectRelative,
                              backgroundColor: Colors.white,
                              icon: Image.asset('assets/icons/home/send.png'),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Section: Health Today
                        Text(
                          'home.health_today'.tr(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.typoBlack,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        HealthStatusSection(onTap: homeNotifier.onUpdateHealth),

                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
