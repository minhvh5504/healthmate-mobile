import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine_reminder/medicine_reminder_notifier.dart';
import '../../../providers/medicine_reminder/medicine_reminder_provider.dart';
import 'medicine_reminder_date_popup.dart';

class MedicineReminderInfoCard extends ConsumerWidget {
  const MedicineReminderInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineReminderProvider);
    final notifier = ref.read(medicineReminderProvider.notifier);

    return Column(
      children: [
        _buildItem(
          context: context,
          icon: LucideIcons.history,
          label: 'medicine.reminder.start'.tr(),
          value: state.getStartDateText(),
          onTap: () {
            notifier.setFocusedDate(state.startDate);
            _showDatePicker(
              context: context,
              title: 'medicine.reminder.start'.tr(),
              isEndDate: false,
              onDateSelected: notifier.updateStartDate,
            );
          },
        ),
        _buildDivider(),
        _buildItem(
          context: context,
          icon: LucideIcons.clock,
          label: 'medicine.reminder.end'.tr(),
          value: state.getEndDateText(),
          onTap: () {
            notifier.setFocusedDate(state.endDate ?? state.startDate);
            _showDatePicker(
              context: context,
              title: 'medicine.reminder.end'.tr(),
              isEndDate: true,
              onDateSelected: notifier.updateEndDate,
            );
          },
        ),
        _buildDivider(),
        _buildFrequencyDropdown(context, state, notifier),
        _buildDivider(),
      ],
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF64748B), size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              LucideIcons.chevronRight,
              color: const Color(0xFFCBD5E1),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyDropdown(
    BuildContext context,
    MedicineReminderState state,
    MedicineReminderNotifier notifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.refreshCcw,
                color: const Color(0xFF64748B),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'medicine.reminder.frequency'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              Flexible(
                child: _FrequencyDropdown(
                  value: state.frequency,
                  displayText: notifier.getFrequencyText(),
                  onChanged: notifier.updateFrequency,
                ),
              ),
            ],
          ),
          if (state.frequency == 'specific_days') ...[
            SizedBox(height: 12.h),
            _buildDaysSelection(state, notifier),
          ],
        ],
      ),
    );
  }

  Widget _buildDaysSelection(
    MedicineReminderState state,
    MedicineReminderNotifier notifier,
  ) {
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
          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final isSelected = state.selectedDays.contains(day['val']);
          return GestureDetector(
            onTap: () => notifier.toggleDay(day['val'] as int),
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppColors.activeGradient : null,
                color: isSelected ? null : const Color(0xFFF1F5F9),
              ),
              child: Center(
                child: Text(
                  day['label'].toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
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

  void _showDatePicker({
    required BuildContext context,
    required String title,
    bool isEndDate = false,
    required Function(DateTime) onDateSelected,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Date Picker',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineReminderDatePopup(
                  title: title,
                  isEndDate: isEndDate,
                  onDateSelected: onDateSelected,
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }
}

class _FrequencyDropdown extends StatefulWidget {
  final String value;
  final String displayText;
  final ValueChanged<String> onChanged;

  const _FrequencyDropdown({
    required this.value,
    required this.displayText,
    required this.onChanged,
  });

  @override
  State<_FrequencyDropdown> createState() => _FrequencyDropdownState();
}

class _FrequencyDropdownState extends State<_FrequencyDropdown> {
  late final ValueNotifier<String?> _selected;

  @override
  void initState() {
    super.initState();
    _selected = ValueNotifier<String?>(widget.value);
  }

  @override
  void didUpdateWidget(covariant _FrequencyDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selected.value = widget.value;
    }
  }

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Map<String, String>>[
      {'value': 'daily', 'label': 'medicine.reminder.daily'.tr()},
      {
        'value': 'specific_days',
        'label': 'medicine.reminder.specific_days'.tr(),
      },
      {'value': 'as_needed', 'label': 'medicine.reminder.as_needed'.tr()},
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        valueListenable: _selected,
        items: items
            .map(
              (item) => DropdownItem<String>(
                value: item['value'],
                height: 44.h,
                child: Text(
                  item['label']!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            _selected.value = value;
            widget.onChanged(value);
          }
        },
        selectedItemBuilder: (context) => items
            .map(
              (_) => Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.displayText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            )
            .toList(),
        buttonStyleData: ButtonStyleData(
          height: 32.h,
          padding: EdgeInsets.zero,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            LucideIcons.chevronDown,
            size: 18.sp,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 200.w,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          offset: Offset(0, -8.h),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }
}
