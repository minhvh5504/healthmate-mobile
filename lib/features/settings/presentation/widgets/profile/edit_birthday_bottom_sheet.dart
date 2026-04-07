import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import 'base_profile_popup.dart';

class EditBirthdayBottomSheet extends StatefulWidget {
  final DateTime? initialValue;
  final Function(DateTime) onSave;

  const EditBirthdayBottomSheet({
    super.key,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<EditBirthdayBottomSheet> createState() =>
      _EditBirthdayBottomSheetState();
}

class _EditBirthdayBottomSheetState extends State<EditBirthdayBottomSheet> {
  late TextEditingController _dayController;
  late TextEditingController _monthController;
  late TextEditingController _yearController;
  final FocusNode _dayFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final date = widget.initialValue?.toUtc() ?? DateTime.utc(2000, 1, 1);
    _dayController = TextEditingController(text: date.day.toString());
    _monthController = TextEditingController(text: date.month.toString());
    _yearController = TextEditingController(text: date.year.toString());
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseProfilePopup(
      title: 'profile.update_birthday'.tr(),
      onSave: () {
        final day = int.tryParse(_dayController.text) ?? 1;
        final month = int.tryParse(_monthController.text) ?? 1;
        final year = int.tryParse(_yearController.text) ?? 2000;

        if (_yearController.text.length < 4 || year < 1700 || year > 2100) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('profile.year_invalid'.tr())));
          return;
        }

        if (day < 1 || day > 31 || month < 1 || month > 12) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('profile.date_invalid'.tr())));
          return;
        }

        widget.onSave(DateTime.utc(year, month, day));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'profile.birthday_subtitle'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.typoNavi.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.help_outline_rounded,
                size: 16.sp,
                color: AppColors.typoNavi,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              _DateInput(
                label: 'profile.day'.tr(),
                controller: _dayController,
                maxLength: 2,
                maxRange: 31,
                focusNode: _dayFocus,
                onChanged: (val) {
                  if (val.length == 2 ||
                      (val.isNotEmpty && int.parse(val) > 3)) {
                    _monthFocus.requestFocus();
                  }
                },
              ),
              SizedBox(width: 12.w),
              _DateInput(
                label: 'profile.month'.tr(),
                controller: _monthController,
                maxLength: 2,
                maxRange: 12,
                focusNode: _monthFocus,
                onChanged: (val) {
                  if (val.length == 2 ||
                      (val.isNotEmpty && int.parse(val) > 1)) {
                    _yearFocus.requestFocus();
                  }
                },
              ),
              SizedBox(width: 12.w),
              _DateInput(
                label: 'profile.year'.tr(),
                controller: _yearController,
                maxLength: 4,
                maxRange: 2100,
                focusNode: _yearFocus,
                flex: 2,
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int flex;
  final int maxLength;
  final int maxRange;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const _DateInput({
    required this.label,
    required this.controller,
    required this.maxLength,
    required this.maxRange,
    this.flex = 1,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.typoBody),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxLength),
              _RangeInputFormatter(max: maxRange, isYear: maxLength == 4),
            ],
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.typoHeading,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.lightPurple),
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.lightPurple),
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.lightPurple),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeInputFormatter extends TextInputFormatter {
  final int max;
  final bool isYear;

  _RangeInputFormatter({required this.max, this.isYear = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    if (!isYear && newValue.text == '00') return oldValue;

    final int? val = int.tryParse(newValue.text);
    if (val == null || val > max) return oldValue;

    if (isYear && newValue.text.length == 4 && val < 1700) return oldValue;

    return newValue;
  }
}
