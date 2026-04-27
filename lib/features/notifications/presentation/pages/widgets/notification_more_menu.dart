import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/dialog/not_found_dialog.dart';

class NotificationMoreMenu {
  static Future<String?> show(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

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
          value: 'mark_read',
          child: Row(
            children: [
              Icon(Icons.done_all_rounded, size: 20.sp, color: Colors.blue),
              SizedBox(width: 12.w),
              Text(
                'notifications.mark_all_read'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete_all',
          child: Row(
            children: [
              Icon(Icons.delete_sweep_rounded, size: 20.sp, color: Colors.red),
              SizedBox(width: 12.w),
              Text(
                'notifications.delete_all'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );

    if (!context.mounted) return null;

    if (result == 'mark_read') {
      bool confirmed = false;
      await showDialog(
        context: context,
        builder: (context) => AccountNotFoundDialog(
          title: 'notifications.confirm_mark_read_all_title'.tr(),
          message: 'notifications.confirm_mark_read_all_message'.tr(),
          primaryButtonText: 'dialog.confirm'.tr(),
          secondaryButtonText: 'dialog.cancel'.tr(),
          onPrimaryPressed: () => confirmed = true,
          onSecondaryPressed: () {},
        ),
      );
      if (!context.mounted) return null;
      return confirmed ? 'mark_read' : null;
    }

    if (result == 'delete_all') {
      bool confirmed = false;
      await showDialog(
        context: context,
        builder: (context) => AccountNotFoundDialog(
          title: 'notifications.confirm_delete_all_title'.tr(),
          message: 'notifications.confirm_delete_all_message'.tr(),
          primaryButtonText: 'dialog.delete'.tr(),
          secondaryButtonText: 'dialog.cancel'.tr(),
          onPrimaryPressed: () => confirmed = true,
          onSecondaryPressed: () {},
        ),
      );
      if (!context.mounted) return null;
      return confirmed ? 'delete_all' : null;
    }

    return result;
  }
}
