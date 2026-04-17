import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../../domain/entities/medication_condition.dart';

class MedicineConditionPopup extends StatefulWidget {
  final List<MedicationCondition> conditions;
  final bool isLoading;
  final String initialValue;
  final Function(String) onSave;

  const MedicineConditionPopup({
    super.key,
    required this.conditions,
    this.isLoading = false,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<MedicineConditionPopup> createState() => _MedicineConditionPopupState();
}

class _MedicineConditionPopupState extends State<MedicineConditionPopup> {
  String? _selectedConditionId;
  late TextEditingController _customController;
  bool _isOtherSelected = false;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
    _initializeSelection();
  }

  void _initializeSelection() {
    final initial = widget.initialValue;
    if (initial == '-' || initial.isEmpty) return;

    final match = widget.conditions.cast<MedicationCondition?>().firstWhere(
      (c) =>
          c?.name == initial ||
          c?.slug == initial ||
          'medicine.condition.${c?.slug}'.tr() == initial,
      orElse: () => null,
    );

    if (match != null) {
      _selectedConditionId = match.id;
    } else {
      _isOtherSelected = true;
      _customController.text = initial;
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'medicine.condition.title'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF14141E),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        LucideIcons.x,
                        color: const Color(0xFF94A3B8),
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conditions List or Loading
            if (widget.isLoading && widget.conditions.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 48.h),
                child: const CircularProgressIndicator(),
              )
            else
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 450.h),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        ...widget.conditions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final condition = entry.value;
                          final isSelected =
                              _selectedConditionId == condition.id &&
                              !_isOtherSelected;
                          return Column(
                            children: [
                              _buildConditionItem(condition, isSelected),
                              if (index < widget.conditions.length - 1)
                                Divider(
                                  height: 1,
                                  color: const Color(0xFFF1F5F9),
                                  indent: 60.w,
                                ),
                            ],
                          );
                        }),
                        if (widget.conditions.isNotEmpty)
                          Divider(
                            height: 1,
                            color: const Color(0xFFF1F5F9),
                            indent: 60.w,
                          ),
                        _buildOtherItem(),
                      ],
                    ),
                  ),
                ),
              ),

            // Input Field
            if (_isOtherSelected)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: const Color(0xFFEDF2F7),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _customController,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF14141E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'medicine.condition.placeholder'.tr(),
                      hintStyle: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFFCBD5E1),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

            // Save Button
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
              child: Button(
                text: 'medicine.condition.save'.tr(),
                height: 48.h,
                width: double.infinity,
                onPressed: () {
                  if (_isOtherSelected) {
                    widget.onSave(_customController.text);
                  } else if (_selectedConditionId != null) {
                    final condition = widget.conditions.firstWhere(
                      (c) => c.id == _selectedConditionId,
                    );
                    widget.onSave('medicine.condition.${condition.slug}'.tr());
                  }
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(MedicationCondition condition, bool isSelected) {
    final label = 'medicine.condition.${condition.slug}'.tr();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConditionId = condition.id;
          _isOtherSelected = false;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            _buildIconBox(condition.slug),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF14141E),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.checkCircle2,
                color: const Color(0xFF10B981),
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherItem() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedConditionId = null;
          _isOtherSelected = true;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                LucideIcons.moreHorizontal,
                color: const Color(0xFF94A3B8),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'medicine.condition.other'.tr(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: _isOtherSelected
                      ? const Color(0xFF10B981)
                      : const Color(0xFF14141E),
                ),
              ),
            ),
            if (_isOtherSelected)
              Icon(
                LucideIcons.checkCircle2,
                color: const Color(0xFF10B981),
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(String slug) {
    Color bg;
    Color color;
    IconData icon;

    switch (slug) {
      case 'diabetes':
        bg = const Color(0xFFE0F2FE);
        color = const Color(0xFF3B82F6);
        icon = LucideIcons.droplet;
        break;
      case 'angina':
        bg = const Color(0xFFFEE2E2);
        color = const Color(0xFFEF4444);
        icon = LucideIcons.flame;
        break;
      case 'high_cholesterol':
      case 'high-cholesterol':
        bg = const Color(0xFFFFF7ED);
        color = const Color(0xFFF59E0B);
        icon = LucideIcons.droplet;
        break;
      case 'digestive_health':
      case 'digestive-health':
        bg = const Color(0xFFFEF2F2);
        color = const Color(0xFFF43F5E);
        icon = LucideIcons.zap;
        break;
      case 'varicose_veins':
      case 'varicose-veins':
        bg = const Color(0xFFFFF7ED);
        color = const Color(0xFFFB923C);
        icon = LucideIcons.accessibility;
        break;
      case 'heart_failure':
      case 'heart-failure':
        bg = const Color(0xFFFEF2F2);
        color = const Color(0xFFEF4444);
        icon = LucideIcons.heart;
        break;
      case 'hypertension':
      case 'high_blood_pressure':
      case 'high-blood-pressure':
        bg = const Color(0xFFE0F2FE);
        color = const Color(0xFF2563EB);
        icon = LucideIcons.gauge;
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        color = const Color(0xFF94A3B8);
        icon = LucideIcons.pill;
    }

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
