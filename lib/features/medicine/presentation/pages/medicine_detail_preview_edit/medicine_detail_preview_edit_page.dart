import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../providers/medicine_detail_preview_edit/medicine_detail_preview_edit_provider.dart';
import 'widgets/medicine_detail_content_card.dart';
import 'widgets/medicine_detail_icon.dart';
import 'widgets/medicine_detail_search_input.dart';
import 'widgets/medicine_detail_search_view.dart';
import 'widgets/medicine_detail_title.dart';
import 'widgets/medicine_details_header.dart';

class MedicineDetailPreviewEditPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> medication;

  const MedicineDetailPreviewEditPage({
    super.key,
    required this.medication,
  });

  @override
  ConsumerState<MedicineDetailPreviewEditPage> createState() =>
      _MedicineDetailPreviewEditPageState();
}

class _MedicineDetailPreviewEditPageState
    extends ConsumerState<MedicineDetailPreviewEditPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineDetailPreviewEditProvider.notifier).init(widget.medication);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineDetailPreviewEditProvider);
    final notifier = ref.read(medicineDetailPreviewEditProvider.notifier);

    final name = state.name;
    final manufacturer = state.manufacturer;
    final isSearchMode = state.isSearchMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              if (!isSearchMode)
                MedicineDetailsHeader(
                  name: name,
                  manufacturer: manufacturer,
                  onBack: notifier.onBack,
                )
              else
                SizedBox(height: 16.h),

              if (isSearchMode)
                const MedicineDetailSearchInput()
              else
                const SizedBox.shrink(),

              if (isSearchMode) ...[
                const MedicineDetailSearchView(),
              ] else
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        const MedicineDetailIcon(),
                        SizedBox(height: 24.h),
                        MedicineDetailTitle(
                          title: 'medicine.preview.edit'.tr(),
                          subtitle: 'medicine.preview.info_subtitle'.tr(),
                        ),
                        SizedBox(height: 24.h),
                        const MedicineDetailContentCard(),
                      ],
                    ),
                  ),
                ),

              if (!isSearchMode)
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  child: Button(
                    text: 'medicine_stock.save'.tr(),
                    onPressed: notifier.onSave,
                    height: 48.h,
                    width: double.infinity,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
