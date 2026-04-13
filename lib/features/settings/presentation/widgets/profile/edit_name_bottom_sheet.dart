import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import 'base_profile_popup.dart';

class EditNameBottomSheet extends StatefulWidget {
  final String initialValue;
  final Function(String) onSave;

  const EditNameBottomSheet({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<EditNameBottomSheet> createState() => _EditNameBottomSheetState();
}

class _EditNameBottomSheetState extends State<EditNameBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProfilePopup(
      title: 'profile.my_name'.tr(),
      onSave: () => widget.onSave(_controller.text),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            autofocus: true,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoNavi,
            ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.bgHover),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.typoNavi),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
