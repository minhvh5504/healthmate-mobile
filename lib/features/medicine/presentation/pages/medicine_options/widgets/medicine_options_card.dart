import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_medication.dart';
import '../../../providers/medicine/medicine_provider.dart';
import '../../../providers/medicine_options/medicine_options_provider.dart';
import '../../medicine_detail_preview/widgets/medicine_detail_item.dart';

class MedicineOptionsCard extends ConsumerWidget {
  final UserMedication? medication;

  const MedicineOptionsCard({super.key, this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find latest medication data from provider to enable automatic refresh
    final medications = ref.watch(medicineProvider).activeMedications;
    final latestMedication = medications.cast<UserMedication?>().firstWhere(
      (m) => m?.id == medication?.id,
      orElse: () => medication,
    );

    final notifier = ref.read(medicineOptionsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.typoBody.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          if (latestMedication == null) ...[
            MedicineDetailItem(
              icon: LucideIcons.checkCircle,
              title: 'medicine.options.save_info'.tr(),
              titleColor: AppColors.typoPrimary,
              onTap: () {
                notifier.onSaveNewMedication();
              },
            ),
          ] else ...[
            MedicineDetailItem(
              icon: LucideIcons.pill,
              title: 'medicine.options_popup.edit_details'.tr(),
              onTap: () {
                notifier.onEditDetails(latestMedication);
              },
            ),
            _buildDivider(),
            MedicineDetailItem(
              icon: LucideIcons.clock,
              title: 'medicine.options_popup.change_schedule'.tr(),
              onTap: () {
                notifier.onSchedule(latestMedication);
              },
            ),
          ],
          _buildDivider(),
          MedicineDetailItem(
            icon: LucideIcons.plus,
            title: 'medicine.options_popup.add_medicine'.tr(),
            onTap: () {
              notifier.onAddMedicine(latestMedication);
            },
          ),
          if (latestMedication != null) ...[
            _buildDivider(),
            MedicineDetailItem(
              icon: LucideIcons.trash2,
              title: 'medicine.options.stop_medicine'.tr(),
              onTap: () {
                notifier.onStopMedication(context, latestMedication);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.typoBody.withValues(alpha: 0.05),
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
