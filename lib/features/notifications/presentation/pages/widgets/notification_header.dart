import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/notifications/presentation/providers/notification_notifier.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/header/header_with_back.dart';

class NotificationHeader extends StatelessWidget {
  final NotificationNotifier notifier;

  const NotificationHeader({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: HeaderWithBack(
            showTitle: false,
            onBack: () => context.pop(),
            onMore: () => notifier.onShowMoreMenu(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'notifications.title'.tr(),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.typoBlack,
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
