import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/widgets/dialog/not_found_dialog.dart';
import 'package:healthmate_mobile/core/widgets/header/header_with_back.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool hasMessages;
  final VoidCallback onBack;
  final VoidCallback? onClearHistory;

  const ChatHeader({
    super.key,
    required this.hasMessages,
    required this.onBack,
    this.onClearHistory,
  });

  void _showMenu(BuildContext context) async {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (button == null || overlay == null) return;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(overlay.size.width - 60.w, 45.h),
          ancestor: overlay,
        ),
        button.localToGlobal(
          Offset(overlay.size.width - 10.w, 55.h),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      items: [
        PopupMenuItem(
          value: 'clear_history',
          child: Row(
            children: [
              Icon(Icons.delete_sweep_rounded, size: 20.sp, color: Colors.red),
              SizedBox(width: 12.w),
              Text(
                'chat.clear_history'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );

    if (!context.mounted) return;

    if (result == 'clear_history') {
      bool confirmed = false;
      await showDialog(
        context: context,
        builder: (context) => AccountNotFoundDialog(
          title: 'chat.confirm_clear_title'.tr(),
          message: 'chat.confirm_clear_message'.tr(),
          primaryButtonText: 'dialog.confirm'.tr(),
          secondaryButtonText: 'dialog.cancel'.tr(),
          onPrimaryPressed: () => confirmed = true,
          onSecondaryPressed: () {},
        ),
      );
      if (!context.mounted) return;
      if (confirmed) {
        onClearHistory?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWithBack(
      title: hasMessages ? 'chat.title'.tr() : null,
      showTitle: hasMessages,
      showMore: true,
      onBack: onBack,
      onMore: () => _showMenu(context),
      topPadding: 0,
      horizontalPadding: 16.w,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
