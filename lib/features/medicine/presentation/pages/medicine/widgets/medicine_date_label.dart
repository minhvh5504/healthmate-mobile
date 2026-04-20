import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../providers/medicine/medicine_provider.dart';

class MedicineDateLabel extends ConsumerWidget {
  const MedicineDateLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child: Text(
          _formatDateLabel(state.selectedDate, context),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.bgError,
          ),
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final locale = EasyLocalization.of(context)?.currentLocale?.languageCode;
    final formatted = DateFormat('d MMM', locale).format(date);
    if (isToday) {
      return '${'medicine.today'.tr()}, $formatted';
    }
    return formatted;
  }
}
