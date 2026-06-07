import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/home_provider.dart';
import 'shortcut_card.dart';

class HomeShortcutsSection extends ConsumerWidget {
  const HomeShortcutsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Expanded(
              child: HomeShortcutCard(
                label: 'home.ai_assistant'.tr(),
                subtitle: 'home.ai_assistant_subtitle'.tr(),
                onTap: homeNotifier.onAiAssistant,
                backgroundColor: Colors.white,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE2E8F0), Color(0xFF93C5FD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Image.asset(AppIcons.ai, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 22.w),
            // Connect relative card
            Expanded(
              child: HomeShortcutCard(
                label: 'home.connect_relative'.tr(),
                subtitle: 'home.connect_relative_subtitle'.tr(),
                onTap: homeNotifier.onConnectRelative,
                backgroundColor: Colors.white,
                icon: Image.asset(
                  AppIcons.sendPng,
                  fit: BoxFit.contain,
                  height: 28.h,
                  width: 28.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
