import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine_flow/medicine_flow_provider.dart';
import '../../providers/medicine_stock/medicine_stock_provider.dart';
import 'widgets/medicine_stock_card.dart';
import 'widgets/medicine_stock_header.dart';
import 'widgets/medicine_stock_save_button.dart';
import 'widgets/medicine_stock_title.dart';
import 'widgets/medicine_stock_top_icon.dart';

class MedicineStockPage extends ConsumerStatefulWidget {
  const MedicineStockPage({super.key});

  @override
  ConsumerState<MedicineStockPage> createState() => _MedicineStockPageState();
}

class _MedicineStockPageState extends ConsumerState<MedicineStockPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialData = ref.read(medicineFlowProvider).toMap();
      ref.read(medicineStockProvider.notifier).init(initialData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const MedicineStockHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      const MedicineStockTopIcon(),
                      SizedBox(height: 8.h),
                      const MedicineStockTitle(),
                      SizedBox(height: 32.h),
                      const MedicineStockCard(),
                      const MedicineStockSaveButton(),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
