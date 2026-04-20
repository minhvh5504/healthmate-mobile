import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MedicineDetailSearchResultItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? manufacturer;
  final VoidCallback onTap;

  const MedicineDetailSearchResultItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.manufacturer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4.h),
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              if (manufacturer != null)
                Text(
                  manufacturer!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
            ],
          ),
          trailing: const Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
