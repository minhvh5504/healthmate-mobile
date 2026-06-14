import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/notifications/presentation/providers/notification_notifier.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/header/header_with_back.dart';

class NotificationHeader extends StatelessWidget {
  final NotificationNotifier notifier;
  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onFilterChanged;

  const NotificationHeader({
    super.key,
    required this.notifier,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _NotificationFilterTabs(
            selectedFilter: selectedFilter,
            onChanged: onFilterChanged,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

class _NotificationFilterTabs extends StatelessWidget {
  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onChanged;

  const _NotificationFilterTabs({
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _buildTab(
            filter: NotificationFilter.all,
            label: 'notifications.filter_all'.tr(),
          ),
          _buildTab(
            filter: NotificationFilter.today,
            label: 'notifications.filter_today'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required NotificationFilter filter,
    required String label,
  }) {
    final isSelected = selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.typoPrimary : AppColors.typoNavi,
            ),
          ),
        ),
      ),
    );
  }
}
