import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../providers/health_history/health_history_provider.dart';

class ViewAllHealthHistoryItem extends StatelessWidget {
  final HealthHistoryEntry entry;
  final String unit;

  const ViewAllHealthHistoryItem({
    super.key,
    required this.entry,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatValue(entry.value),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1D1730),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      unit,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 12.sp,
                      color: const Color(0xFF98A2B3),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(entry.recordedAt),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF98A2B3),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      LucideIcons.clock,
                      size: 12.sp,
                      color: const Color(0xFF98A2B3),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatTime(entry.recordedAt),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF98A2B3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _TrendBadge(
            icon: _icon(),
            iconColor: _iconColor(),
            backgroundColor: _iconBackgroundColor(),
            label: _changeLabel(),
          ),
        ],
      ),
    );
  }

  IconData _icon() {
    switch (entry.direction) {
      case 'up':
        return LucideIcons.arrowUp;
      case 'down':
        return LucideIcons.arrowDown;
      case 'same':
        return LucideIcons.minus;
      default:
        return LucideIcons.activity;
    }
  }

  Color _iconColor() {
    switch (entry.direction) {
      case 'up':
        return const Color(0xFF12B76A);
      case 'down':
        return const Color(0xFFF04438);
      case 'same':
        return const Color(0xFF667085);
      default:
        return const Color(0xFF4F46E5);
    }
  }

  Color _iconBackgroundColor() {
    switch (entry.direction) {
      case 'up':
        return const Color(0xFFECFDF3);
      case 'down':
        return const Color(0xFFFEF3F2);
      case 'same':
        return const Color(0xFFF2F4F7);
      default:
        return const Color(0xFFEEF2FF);
    }
  }

  String _changeLabel() {
    final change = entry.change;
    if (change == null) return 'health.history_initial_change'.tr();
    final prefix = entry.direction == 'up'
        ? '+'
        : entry.direction == 'down'
        ? '-'
        : '';
    return '$prefix${_formatValue(change.abs())} $unit';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
