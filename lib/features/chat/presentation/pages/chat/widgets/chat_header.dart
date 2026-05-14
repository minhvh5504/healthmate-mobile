import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/widgets/header/header_with_back.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool hasMessages;
  final VoidCallback onBack;

  const ChatHeader({
    super.key,
    required this.hasMessages,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderWithBack(
      title: hasMessages ? 'chat.title'.tr() : null,
      showTitle: hasMessages,
      showMore: false,
      onBack: onBack,
      topPadding: 24.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 24.h);
}
