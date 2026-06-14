import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/constant_url.dart';
import '../../../../domain/entities/medication_condition.dart';
import '../../../providers/medicine_detail_preview_edit/medicine_detail_preview_edit_notifier.dart';
import '../../../providers/medicine_detail_preview_edit/medicine_detail_preview_edit_provider.dart';
import '../../medicine/widgets/medicine_condition_popup.dart';
import '../../medicine/widgets/medicine_dosage_popup.dart';
import 'medicine_details_card.dart';

class MedicineDetailContentCard extends ConsumerWidget {
  const MedicineDetailContentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineDetailPreviewEditProvider);
    final notifier = ref.read(medicineDetailPreviewEditProvider.notifier);

    final name = state.name;
    final genericName = state.genericName;

    return Material(
      color: Colors.transparent,
      child: MedicineDetailsCard(
        items: [
          DetailItemData(
            icon: AppIcons.medicine,
            label: 'medicine.preview.name_label'.tr(),
            value: name,
            field: 'name',
            onTap: notifier.onEditName,
          ),
          DetailItemData(
            icon: AppIcons.dosage,
            label: 'medicine.preview.dosage_label'.tr(),
            value:
                state.medication['dosage'] ?? state.medication['dosage'] ?? '-',
            field: 'dosage',
            onTap: () => _showDosagePopup(
              context,
              notifier,
              state.medication['dosage'] ?? state.medication['dosage'] ?? '',
            ),
          ),
          DetailItemData(
            icon: AppIcons.addItem,
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
    );
  }

  void _showDosagePopup(
    BuildContext context,
    MedicineDetailPreviewEditNotifier notifier,
    String initialValue,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Dosage',
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
                child: MedicineDosagePopup(
                  initialDosage: initialValue,
                  onSave: (value) {
                    notifier.updateField('dosage', value);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _showConditionPopup(
    BuildContext context,
    MedicineDetailPreviewEditNotifier notifier,
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
                  onSave: (id, custom, label) {
                    notifier.updateCondition(id, custom, label);
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: anim1,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
