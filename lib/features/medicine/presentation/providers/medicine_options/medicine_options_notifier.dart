import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user_medication.dart';
import '../medicine/medicine_provider.dart';

class MedicineOptionsState {
  final bool isLoading;
  final String? errorMessage;

  MedicineOptionsState({this.isLoading = false, this.errorMessage});

  MedicineOptionsState copyWith({bool? isLoading, String? errorMessage}) {
    return MedicineOptionsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MedicineOptionsNotifier extends StateNotifier<MedicineOptionsState> {
  final Ref ref;

  MedicineOptionsNotifier(this.ref) : super(MedicineOptionsState());

  Future<void> onEditDetails(UserMedication medication) async {
    final result = await AppRouter.router.push(
      AppRoutes.medicineDetailPreviewEdit,
      extra: {
        'id': medication.id,
        'isUpdate': true,
        'name': medication.effectiveName,
        'manufacturer': medication.effectiveManufacturer,
        'strength': medication.medication?.strength,
        'genericName': medication.condition != null
            ? 'medicine.condition.${medication.condition!.slug}'.tr()
            : (medication.conditionCustom ??
                  medication.medication?.genericName),
        'medicationId': medication.medicationId,
        'dosage': medication.dosage,
        'mealInstruction': medication.mealInstruction,
        'mealInstructionNote': medication.mealInstructionNote,
        'conditionId': medication.conditionId,
        'conditionCustom': medication.conditionCustom,
      },
    );

    if (result == true) {
      AppRouter.router.pop();
    }
  }

  Future<void> onSchedule(UserMedication medication) async {
    final List<Map<String, dynamic>> scheduleList =
        medication.reminderSchedules?.map((s) {
          final map = s as Map<String, dynamic>;
          return {
            'time': map['remindTime'] ?? map['time'],
            'doses': int.tryParse(map['dosage']?.toString() ?? '1') ?? 1,
          };
        }).toList() ??
        [];

    final result = await AppRouter.router.push(
      AppRoutes.medicineReminderEdit,
      extra: {
        'id': medication.id,
        'isUpdate': true,
        'name': medication.effectiveName,
        'manufacturer': medication.effectiveManufacturer,
        'strength': medication.medication?.strength,
        'genericName': medication.condition != null
            ? 'medicine.condition.${medication.condition!.slug}'.tr()
            : (medication.conditionCustom ??
                  medication.medication?.genericName),
        'startDate': medication.startDate,
        'endDate': medication.endDate,
        'frequency': medication.frequency ?? 'daily',
        'reminderEnabled': medication.reminderEnabled,
        'schedules': scheduleList,
      },
    );

    if (result == true) {
      AppRouter.router.pop();
    }
  }

  Future<void> onAddMedicine([UserMedication? medication]) async {
    if (medication != null) {
      final result = await AppRouter.router.push(
        AppRoutes.medicineStockEdit,
        extra: {
          'id': medication.id,
          'isUpdate': true,
          'name': medication.effectiveName,
          'manufacturer': medication.effectiveManufacturer,
          'stockCount': medication.stockCount,
          'lowStockThreshold': medication.lowStockThreshold,
          'lowStockReminderEnabled': medication.lowStockReminderEnabled,
        },
      );
      if (result == true) {
        AppRouter.router.pop();
      }
    } else {
      await AppRouter.router.push(AppRoutes.medicineStock);
    }
  }

  void onStopMedication(BuildContext context, UserMedication medication) {
    ref.read(medicineProvider.notifier).onStopMedication(context, medication);
  }

  Future<void> onSaveNewMedication() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // await ref.read(medicineFlowProvider.notifier).submit();

      AppRouter.router.go(AppRoutes.medicine);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
