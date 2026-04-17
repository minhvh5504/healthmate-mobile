import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'medicine_detail_item.dart';

class DetailItemData {
  final IconData icon;
  final String label;
  final String value;
  final String field;
  final VoidCallback onTap;

  DetailItemData({
    required this.icon,
    required this.label,
    required this.value,
    required this.field,
    required this.onTap,
  });
}

class MedicineDetailsCard extends StatelessWidget {
  final List<DetailItemData> items;

  const MedicineDetailsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.typoBody.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              MedicineDetailItem(
                icon: item.icon,
                title: item.label,
                value: item.value,
                onTap: item.onTap,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              ),
              if (index < items.length - 1) _buildDivider(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.typoBody.withValues(alpha: 0.05),
      indent: 60.w,
      endIndent: 20.w,
    );
  }
}
