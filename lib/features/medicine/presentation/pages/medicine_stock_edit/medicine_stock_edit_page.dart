import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine_stock_edit/medicine_stock_edit_provider.dart';
import 'widgets/medicine_stock_card.dart';
import 'widgets/medicine_stock_header.dart';
import 'widgets/medicine_stock_save_button.dart';
import 'widgets/medicine_stock_title.dart';
import 'widgets/medicine_stock_top_icon.dart';

class MedicineStockEditPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> medication;

  const MedicineStockEditPage({super.key, required this.medication});

  @override
  ConsumerState<MedicineStockEditPage> createState() => _MedicineStockEditPageState();
}

class _MedicineStockEditPageState extends ConsumerState<MedicineStockEditPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineStockEditProvider.notifier).init(widget.medication);
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
