import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MedicineDetailIcon extends StatelessWidget {
  const MedicineDetailIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FB),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 20,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Center(
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(45 / 360),
          child: Icon(
            LucideIcons.pill,
            size: 32.sp,
            color: const Color(0xFF5A5D7A),
          ),
        ),
      ),
    );
  }
}
