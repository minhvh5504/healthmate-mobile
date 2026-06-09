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
    if (!_isToday(state.selectedDate)) {
      return const SizedBox.shrink();
    }

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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDateLabel(DateTime date, BuildContext context) {
    final locale = EasyLocalization.of(context)?.currentLocale?.languageCode;
    final formatted = DateFormat('d MMM', locale).format(date);
    return '${'medicine.today'.tr()}, $formatted';
  }
}
