import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineStrengthPopup extends StatefulWidget {
  final String initialStrength;
  final Function(String) onSave;

  const MedicineStrengthPopup({
    super.key,
    required this.initialStrength,
    required this.onSave,
  });

  @override
  State<MedicineStrengthPopup> createState() => _MedicineStrengthPopupState();
}

class _MedicineStrengthPopupState extends State<MedicineStrengthPopup> {
  late TextEditingController _amountController;
  late String _selectedUnit;
  final List<String> _units = ['mL', 'IU', '%', 'mcg', 'mg', 'g'];

  @override
  void initState() {
    super.initState();
    _parseInitialStrength();
  }

  void _parseInitialStrength() {
    final strength = widget.initialStrength;
    if (strength == '-' || strength.isEmpty) {
      _amountController = TextEditingController(text: '0');
      _selectedUnit = 'mg';
      return;
    }

    final regExp = RegExp(r'^(\d+\.?\d*)\s*(\D*)$');
    final match = regExp.firstMatch(strength.trim());

    if (match != null) {
      _amountController = TextEditingController(text: match.group(1));
      final String unit = match.group(2)?.trim() ?? 'mg';
      if (!_units.contains(unit)) {
        /// If unit is not in our list, default to mg or keep it
        _selectedUnit = _units.contains(unit) ? unit : 'mg';
      } else {
        _selectedUnit = unit;
      }
    } else {
      _amountController = TextEditingController(text: '0');
      _selectedUnit = 'mg';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 6.h,
              right: 16.w,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  LucideIcons.x,
                  color: AppColors.typoBody.withValues(alpha: 0.4),
                  size: 24.sp,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'medicine.strength_popup_title'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Strength Display/Input Container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF6F74D2).withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'medicine.strength_label'.tr(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.typoBody,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.typoBlack,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _selectedUnit,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.typoBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Units Grid
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: _units.map((unit) {
                      final isSelected = _selectedUnit == unit;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedUnit = unit),
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width -
                                  24.w * 2 -
                                  24.w * 2 -
                                  12.w * 2) /
                              3,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF14141E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF14141E)
                                  : AppColors.typoHeading.withValues(
                                      alpha: 0.1,
                                    ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              unit,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.typoBlack,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32.h),

                  // Save Button
                  Button(
                    text: 'medicine.save'.tr(),
                    onPressed: () {
                      widget.onSave('${_amountController.text} $_selectedUnit');
                    },
                    height: 56.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
