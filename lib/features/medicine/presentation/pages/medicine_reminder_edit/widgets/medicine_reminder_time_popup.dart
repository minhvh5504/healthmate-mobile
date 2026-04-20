import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineReminderTimePopup extends StatefulWidget {
  final String initialTime;
  final Function(String) onSave;

  const MedicineReminderTimePopup({
    super.key,
    required this.initialTime,
    required this.onSave,
  });

  @override
  State<MedicineReminderTimePopup> createState() =>
      _MedicineReminderTimePopupState();
}

class _MedicineReminderTimePopupState extends State<MedicineReminderTimePopup> {
  late int selectedHour;
  late int selectedMinute;

  @override
  void initState() {
    super.initState();
    final parts = widget.initialTime.split(':');
    selectedHour = int.parse(parts[0]);
    final int actualMin = int.parse(parts[1]);
    // Snap to nearest 5 mins
    selectedMinute = (actualMin / 5).round() * 5;
    if (selectedMinute == 60) selectedMinute = 0;
  }

  final List<int> minuteItems = List.generate(12, (index) => index * 5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.9.sw,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          _buildTopIcon(),
          SizedBox(height: 24.h),
          _buildPicker(),
          SizedBox(height: 32.h),
          Button(
            text: 'medicine.reminder.next'.tr(),
            onPressed: () {
              final h = selectedHour.toString().padLeft(2, '0');
              final m = selectedMinute.toString().padLeft(2, '0');
              widget.onSave('$h:$m');
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
      height: 24.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'medicine.reminder.change_time'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          Positioned(
            right: 0,
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

  Widget _buildTopIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: const BoxDecoration(
        color: AppColors.typoHeading,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(LucideIcons.clock, color: Colors.white, size: 32.sp),
      ),
    );
  }

  Widget _buildPicker() {
    const int infiniteLoopCount = 1000;

    return Container(
      height: 240.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.bgHover),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker.builder(
              childCount: infiniteLoopCount,
              scrollController: FixedExtentScrollController(
                initialItem:
                    (infiniteLoopCount ~/ 2) -
                    ((infiniteLoopCount ~/ 2) % 24) +
                    selectedHour,
              ),
              itemExtent: 44.h,
              onSelectedItemChanged: (index) {
                setState(() => selectedHour = index % 24);
              },
              itemBuilder: (context, index) {
                final displayHour = index % 24;
                final isSelected = selectedHour == displayHour;
                return Center(
                  child: Text(
                    displayHour.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.typoBlack
                          : AppColors.typoDisable,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: CupertinoPicker.builder(
              childCount: infiniteLoopCount,
              scrollController: FixedExtentScrollController(
                initialItem:
                    (infiniteLoopCount ~/ 2) -
                    ((infiniteLoopCount ~/ 2) % 12) +
                    (selectedMinute ~/ 5),
              ),
              itemExtent: 44.h,
              onSelectedItemChanged: (index) {
                setState(() => selectedMinute = (index % 12) * 5);
              },
              itemBuilder: (context, index) {
                final displayMin = (index % 12) * 5;
                final isSelected = selectedMinute == displayMin;
                return Center(
                  child: Text(
                    displayMin.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.typoBlack
                          : AppColors.typoDisable,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
