import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/medicine_stock/medicine_stock_provider.dart';

class MedicineStockSaveButton extends ConsumerWidget {
  const MedicineStockSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineStockProvider);
    final notifier = ref.read(medicineStockProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(top: 32.h),
      child: Button(
        text: 'medicine_stock.continue'.tr(),
        onPressed: state.isLoading ? null : notifier.onSave,
        isLoading: state.isLoading,
        height: 48.h,
        width: double.infinity,
      ),
    );
  }
}
