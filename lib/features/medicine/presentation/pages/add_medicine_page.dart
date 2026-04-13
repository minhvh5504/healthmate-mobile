import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';

import '../providers/add_medicine/add_medicine_provider.dart';
import '../widgets/add_medicine/add_medicine_action_card.dart';
import '../widgets/add_medicine/add_medicine_header.dart';
import '../widgets/add_medicine/add_medicine_search_bar.dart';

class AddMedicinePage extends ConsumerStatefulWidget {
  const AddMedicinePage({super.key});

  @override
  ConsumerState<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends ConsumerState<AddMedicinePage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addMedicineProvider);
    final notifier = ref.read(addMedicineProvider.notifier);
    final isSearchMode = state.isSearchMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF4F6FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSearchMode) ...[
                AddMedicineHeader(
                  title: 'medicine.add_medicine.title'.tr(),
                  onClose: notifier.onClose,
                ),
                SizedBox(height: 8.h),
              ] else
                SizedBox(height: 16.h),
              AddMedicineSearchBar(
                controller: _searchController,
                hintText: 'medicine.add_medicine.search_hint'.tr(),
                showCancel: isSearchMode,
                showClear: isSearchMode,
                onCancel: () {
                  _searchController.clear();
                  notifier.cancelSearch();
                },
                onChanged: notifier.updateSearchQuery,
              ),
              if (state.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (isSearchMode) ...[
                if (state.searchQuery.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                    child: Text(
                      'medicine.add_medicine.search_results'.tr().toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: state.searchResults.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.searchResults.length) {
                          /// Custom medicine option at the end
                          return _buildMedicationItem(
                            context,
                            title: state.searchQuery,
                            subtitle: 'medicine.add_medicine.custom_medicine'
                                .tr(),
                            onTap: () {
                              /// Handle custom medicine
                            },
                          );
                        }

                        final medication = state.searchResults[index];
                        return _buildMedicationItem(
                          context,
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
              ] else ...[
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: AddMedicineActionCard(
                          icon: LucideIcons.scanLine,
                          label: 'medicine.add_medicine.scan_prescription'.tr(),
                          onTap: notifier.onScanPrescription,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: AddMedicineActionCard(
                          icon: LucideIcons.camera,
                          label: 'medicine.add_medicine.scan_box'.tr(),
                          onTap: notifier.onScanMedicineBox,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    String? manufacturer,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4.h),
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              if (manufacturer != null)
                Text(
                  manufacturer,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
            ],
          ),
          trailing: const Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: Color(0xFF1E293B),
          ),
        ),
        /// Divider(color: Colors.grey[100], height: 1),
      ],
    );
  }
}
