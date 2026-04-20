import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';

class MedicineLowStockPopup extends StatefulWidget {
  final bool initialEnabled;
  final int initialThreshold;
  final Function(bool, int) onSave;

  const MedicineLowStockPopup({
    super.key,
    required this.initialEnabled,
    required this.initialThreshold,
    required this.onSave,
  });

  @override
  State<MedicineLowStockPopup> createState() => _MedicineLowStockPopupState();
}

class _MedicineLowStockPopupState extends State<MedicineLowStockPopup> {
  late bool _enabled;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _enabled = widget.initialEnabled;
    _controller = TextEditingController(
      text: widget.initialThreshold.toString(),
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
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 24.w),
              Text(
                'medicine.stock.item_title_reminder'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.typoBlack,
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  LucideIcons.x,
                  size: 20.sp,
                  color: AppColors.typoBody.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildOptionItem(
            'medicine.stock.item_title_reminder'.tr(),
            Switch(
              value: _enabled,
              onChanged: (val) => setState(() => _enabled = val),
              activeTrackColor: const Color(0xFF22C55E),
              activeThumbColor: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          _buildOptionItem(
            'medicine_stock.threshold_label'.tr(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40.w,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'medicine.reminder.doses_count'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.typoBody.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Button(
            text: 'medicine_stock.save'.tr(),
            onPressed: () {
              final val =
                  int.tryParse(_controller.text) ?? widget.initialThreshold;
              widget.onSave(_enabled, val);
              context.pop();
            },
            height: 48.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(String label, Widget trailing) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.typoBody.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.typoBlack,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          trailing,
        ],
      ),
    );
  }
}
