import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../domain/entities/medication_condition.dart';
import '../../providers/medicine_detail_preview/medicine_detail_preview_notifier.dart';
import '../../providers/medicine_detail_preview/medicine_detail_preview_provider.dart';
import '../add_medicine/widgets/add_medicine_search_bar.dart';
import '../medicine/widgets/medicine_strength_popup.dart';
import '../medicine/widgets/medicine_condition_popup.dart';
import 'widgets/medicine_detail_icon.dart';
import 'widgets/medicine_detail_search_result_item.dart';
import 'widgets/medicine_detail_title.dart';
import 'widgets/medicine_details_card.dart';
import 'widgets/medicine_details_header.dart';

class MedicineDetailPreviewPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> medication;

  const MedicineDetailPreviewPage({super.key, required this.medication});

  @override
  ConsumerState<MedicineDetailPreviewPage> createState() =>
      _MedicineDetailPreviewPageState();
}

class _MedicineDetailPreviewPageState
    extends ConsumerState<MedicineDetailPreviewPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicineDetailPreviewProvider.notifier).init(widget.medication);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineDetailPreviewProvider);
    final notifier = ref.read(medicineDetailPreviewProvider.notifier);

    final name = state.name;
    final manufacturer = state.manufacturer;
    final genericName = state.genericName;
    final strength = state.strength;

    final isSearchMode = state.isSearchMode;

    if (isSearchMode && _searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
    }

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
                AddMedicineSearchBar(
                  controller: _searchController,
                  hintText: 'medicine.add_medicine.search_hint'.tr(),
                  showCancel: true,
                  showClear: true,
                  onCancel: () {
                    _searchController.clear();
                    notifier.cancelSearch();
                  },
                  onChanged: notifier.updateSearchQuery,
                )
              else
                Container(),

              if (state.isLoading && isSearchMode)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (isSearchMode) ...[
                if (state.searchQuery.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'medicine.add_medicine.search_results'
                            .tr()
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: state.searchResults.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.searchResults.length) {
                          return MedicineDetailSearchResultItem(
                            title: state.searchQuery,
                            subtitle: 'medicine.add_medicine.custom_medicine'
                                .tr(),
                            onTap: () =>
                                notifier.onCustomMedicine(state.searchQuery),
                          );
                        }

                        final medication = state.searchResults[index];
                        return MedicineDetailSearchResultItem(
                          title: medication.name,
                          subtitle: medication.genericName ?? 'Khác',
                          manufacturer: medication.manufacturer,
                          onTap: () => notifier.onSelectMedication(medication),
                        );
                      },
                    ),
                  ),
                ] else
                  const Spacer(),
              ] else
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        const MedicineDetailIcon(),
                        SizedBox(height: 24.h),
                        const MedicineDetailTitle(
                          title: 'Xem lại',
                          subtitle: 'chi tiết thuốc',
                        ),
                        SizedBox(height: 24.h),
                        Material(
                          color: Colors.transparent,
                          child: MedicineDetailsCard(
                            items: [
                              DetailItemData(
                                icon: LucideIcons.pill,
                                label: 'Tên',
                                value: name,
                                field: 'name',
                                onTap: notifier.onEditName,
                              ),
                              DetailItemData(
                                icon: LucideIcons.droplet,
                                label: 'Hàm lượng',
                                value: strength,
                                field: 'strength',
                                onTap: () => _showStrengthPopup(
                                  context,
                                  notifier,
                                  strength,
                                ),
                              ),
                              DetailItemData(
                                icon: LucideIcons.plusSquare,
                                label: 'medicine.condition.label'.tr(),
                                value: genericName,
                                field: 'genericName',
                                onTap: () {
                                  _showConditionPopup(
                                    context,
                                    notifier,
                                    state.medicationConditions,
                                    state.isLoading,
                                    genericName,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isSearchMode)
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  child: Button(
                    text: 'Tiếp tục',
                    onPressed: notifier.onContinue,
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

  void _showStrengthPopup(
    BuildContext context,
    MedicineDetailPreviewNotifier notifier,
    String initialValue,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Strength',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineStrengthPopup(
                  initialStrength: initialValue,
                  onSave: (value) {
                    notifier.updateField('strength', value);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  void _showConditionPopup(
    BuildContext context,
    MedicineDetailPreviewNotifier notifier,
    List<MedicationCondition> conditions,
    bool isLoading,
    String initialValue,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Condition',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.backgroundGradient,
                  ),
                ),
              ),
              Center(
                child: MedicineConditionPopup(
                  conditions: conditions,
                  isLoading: isLoading,
                  initialValue: initialValue,
                  onSave: (value) {
                    notifier.updateField('genericName', value);
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }
}
