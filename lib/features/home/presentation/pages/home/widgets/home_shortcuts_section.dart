import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.typoBlack,
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: HomeShortcutCard(
                label: 'home.ai_assistant'.tr(),
                subtitle: 'home.ai_assistant_subtitle'.tr(),
                onTap: homeNotifier.onAiAssistant,
                backgroundColor: Colors.white,
                iconWidth: 54.w,
                iconHeight: 54.w,
                gradient: const RadialGradient(
                  colors: [Color(0xFF8ED8FF), Color(0xFF4DADF0)],
                  radius: 0.72,
                ),
                icon: Image.asset(
                  'assets/icons/home/ai.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: HomeShortcutCard(
                label: 'home.connect_relative'.tr(),
                subtitle: 'home.connect_relative_subtitle'.tr(),
                onTap: homeNotifier.onConnectRelative,
                backgroundColor: Colors.white,
                iconWidth: 30.w,
                iconHeight: 30.w,
                icon: SvgPicture.asset('assets/icons/home/send.svg'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
