import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HealthHistoryAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const HealthHistoryAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.w,
      bottom: 0.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: const Color(0xFF1D1730),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D1730).withValues(alpha: 0.24),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Icon(LucideIcons.plus, color: Colors.white, size: 34.sp),
        ),
      ),
    );
  }
}
