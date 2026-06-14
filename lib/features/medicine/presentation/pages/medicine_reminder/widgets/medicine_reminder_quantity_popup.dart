import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineReminderQuantityPopup extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onSave;

  const MedicineReminderQuantityPopup({
    super.key,
    required this.initialQuantity,
    required this.onSave,
  });

  @override
  State<MedicineReminderQuantityPopup> createState() =>
      _MedicineReminderQuantityPopupState();
}

class _MedicineReminderQuantityPopupState
    extends State<MedicineReminderQuantityPopup> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialQuantity.clamp(1, 999).toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.9.sw,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          _buildInput(context),
          SizedBox(height: 32.h),
          Button(
            text: 'medicine.reminder.save'.tr(),
            onPressed: () {
              final value = int.tryParse(_controller.text.trim()) ?? 1;
              widget.onSave(value.clamp(1, 999).toInt());
            },
            height: 48.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'medicine.reminder.change_quantity'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.typoBlack,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: -5.h,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                LucideIcons.x,
                color: const Color(0xFF64748B),
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.typoBlack,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'medicine.reminder.doses_count'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoBody,
            ),
          ),
        ],
      ),
    );
  }
}
