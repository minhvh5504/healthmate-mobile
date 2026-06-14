import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';

class MedicineReminderFrequencyPopup extends StatefulWidget {
  final String initialFrequency;
  final List<int> initialSelectedDays;
  final Function(String frequency, List<int> selectedDays) onSave;

  const MedicineReminderFrequencyPopup({
    super.key,
    required this.initialFrequency,
    required this.initialSelectedDays,
    required this.onSave,
  });

  @override
  State<MedicineReminderFrequencyPopup> createState() =>
      _MedicineReminderFrequencyPopupState();
}

class _MedicineReminderFrequencyPopupState
    extends State<MedicineReminderFrequencyPopup> {
  late String _selectedFrequency;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.initialFrequency;
    _selectedDays = List<int>.from(widget.initialSelectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
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
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildOptionItem(
                    label: 'medicine.reminder.daily'.tr(),
                    value: 'daily',
                  ),
                  _buildDivider(),
                  _buildOptionItem(
                    label: 'medicine.reminder.specific_days'.tr(),
                    value: 'specific_days',
                    showDaysSelector: true,
                  ),
                  _buildDivider(),
                  _buildOptionItem(
                    label: 'medicine.reminder.as_needed'.tr(),
                    value: 'as_needed',
                  ),
                  SizedBox(height: 32.h),
                  _buildSaveButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            'medicine.reminder.frequency'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        Positioned(
          top: 12.h,
          right: 12.w,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              LucideIcons.x,
              color: const Color(0xFF94A3B8),
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem({
    required String label,
    required String value,
    bool showDaysSelector = false,
  }) {
    final isSelected = _selectedFrequency == value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedFrequency = value;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF2AC06D)
                        : const Color(0xFF1E293B),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF2AC06D),
                    size: 24.sp,
                  )
                else
                  const SizedBox(width: 24, height: 24),
              ],
            ),
          ),
        ),
        if (showDaysSelector && isSelected) ...[
          _buildDaysSelector(),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }

  Widget _buildDaysSelector() {
    final days = [
      {'val': 1, 'label': 'medicine.reminder.mon'.tr()},
      {'val': 2, 'label': 'medicine.reminder.tue'.tr()},
      {'val': 3, 'label': 'medicine.reminder.wed'.tr()},
      {'val': 4, 'label': 'medicine.reminder.thu'.tr()},
      {'val': 5, 'label': 'medicine.reminder.fri'.tr()},
      {'val': 6, 'label': 'medicine.reminder.sat'.tr()},
      {'val': 7, 'label': 'medicine.reminder.sun'.tr()},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final dayVal = day['val'] as int;
          final isDaySelected = _selectedDays.contains(dayVal);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isDaySelected) {
                  _selectedDays.remove(dayVal);
                } else {
                  _selectedDays.add(dayVal);
                }
              });
            },
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDaySelected ? AppColors.activeGradient : null,
                color: isDaySelected ? null : const Color(0xFFF1F5F9),
              ),
              child: Center(
                child: Text(
                  day['label'].toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        isDaySelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9));
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {
          widget.onSave(_selectedFrequency, _selectedDays);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Text(
          'medicine_stock.save'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
