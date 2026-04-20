import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/medication_condition.dart';
import '../../../providers/medicine_detail_preview/medicine_detail_preview_notifier.dart';
import '../../../providers/medicine_detail_preview/medicine_detail_preview_provider.dart';
import '../../medicine/widgets/medicine_condition_popup.dart';
import '../../medicine/widgets/medicine_strength_popup.dart';
import 'medicine_details_card.dart';

class MedicineDetailContentCard extends ConsumerWidget {
  const MedicineDetailContentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicineDetailPreviewProvider);
    final notifier = ref.read(medicineDetailPreviewProvider.notifier);

    final name = state.name;
    final genericName = state.genericName;
    final strength = state.strength;

    return Material(
      color: Colors.transparent,
      child: MedicineDetailsCard(
        items: [
          DetailItemData(
            icon: LucideIcons.pill,
            label: 'medicine.preview.name_label'.tr(),
            value: name,
            field: 'name',
            onTap: notifier.onEditName,
          ),
          DetailItemData(
            icon: LucideIcons.droplet,
            label: 'medicine.preview.strength_label'.tr(),
            value: strength,
            field: 'strength',
            onTap: () => _showStrengthPopup(context, notifier, strength),
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
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }
}
