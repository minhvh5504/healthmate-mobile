import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/record_medication_log.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/update_medication_log.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/update_user_medication.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../pages/medicine/widgets/medicine_quantity_popup.dart';
import '../../pages/medicine_options/widgets/stop_medication_popup.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../features/auth/presentation/providers/auth/auth_provider.dart';
import '../../../../auth/presentation/providers/auth/auth_notifier.dart';
import '../../../domain/usecases/get_user_medications.dart';
import '../../../domain/usecases/get_daily_schedule.dart';
import '../../../domain/entities/user_medication.dart';
import '../../../domain/entities/scan_task.dart';
import '../../../domain/entities/daily_schedule.dart';
import '../../../domain/entities/daily_schedule_item.dart';
import '../../../domain/repositories/medication_repository.dart';

enum MedicineTab { schedule, cabinet }

/// State
class MedicineState {
  final MedicineTab selectedTab;
  final DateTime selectedDate;
  final bool isLoading;
  final String? errorMessage;
  final List<ScanTask> scanTasks;
  final List<UserMedication> activeMedications;
  final List<UserMedication> inactiveMedications;
  final List<Map<String, dynamic>> reviewMedications;
  final String? reviewImagePath;
  final DailySchedule? dailySchedule;
  final bool isInitialLoad;

  MedicineState({
    this.selectedTab = MedicineTab.schedule,
    DateTime? selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.scanTasks = const [],
    this.activeMedications = const [],
    this.inactiveMedications = const [],
    this.reviewMedications = const [],
    this.reviewImagePath,
    this.dailySchedule,
    this.isInitialLoad = true,
  }) : selectedDate = selectedDate ?? DateTime.now();

  MedicineState copyWith({
    MedicineTab? selectedTab,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    List<ScanTask>? scanTasks,
    List<UserMedication>? activeMedications,
    List<UserMedication>? inactiveMedications,
    List<Map<String, dynamic>>? reviewMedications,
    String? reviewImagePath,
    DailySchedule? dailySchedule,
    bool? isInitialLoad,
  }) {
    return MedicineState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      scanTasks: scanTasks ?? this.scanTasks,
      activeMedications: activeMedications ?? this.activeMedications,
      inactiveMedications: inactiveMedications ?? this.inactiveMedications,
      reviewMedications: reviewMedications ?? this.reviewMedications,
      reviewImagePath: reviewImagePath ?? this.reviewImagePath,
      dailySchedule: dailySchedule ?? this.dailySchedule,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
    );
  }
}

/// Notifier
class MedicineNotifier extends StateNotifier<MedicineState> {
  final Ref ref;
  final MedicationRepository _repository;
  final GetUserMedications _getUserMedications;
  final UpdateUserMedication _updateUserMedication;
  final GetDailyScheduleUseCase _getDailySchedule;
  final RecordMedicationLog _recordMedicationLog;
  final UpdateMedicationLog _updateMedicationLog;

  MedicineNotifier(
    this.ref,
    this._repository,
    this._getUserMedications,
    this._updateUserMedication,
    this._getDailySchedule,
    this._recordMedicationLog,
    this._updateMedicationLog,
  ) : super(MedicineState()) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn && next.accessToken != null) {
        if (previous?.isLoggedIn != true) {
          ref.read(userProfileProvider.notifier).fetchProfile();
          fetchActiveMedications();
        }
      }
    });
    final auth = ref.read(authProvider);
    if (auth.isLoggedIn && auth.accessToken != null) {
      ref.read(userProfileProvider.notifier).fetchProfile();
      fetchActiveMedications();
    }
  }

  static String getInstructionSlugFromTime(String time) {
    final parts = time.split(':').map((e) => int.parse(e)).toList();
    final minutes = parts[0] * 60 + parts[1];

    if (minutes <= 8 * 60) return 'before_breakfast';
    if (minutes <= 10 * 60) return 'after_breakfast';
    if (minutes <= 11 * 60 + 30) return 'between_meals';
    if (minutes <= 12 * 60 + 30) return 'before_lunch';
    if (minutes <= 14 * 60) return 'after_lunch';
    if (minutes <= 17 * 60 + 30) return 'between_meals';
    if (minutes <= 18 * 60 + 30) return 'before_dinner';
    if (minutes <= 20 * 60) return 'after_dinner';
    return 'before_sleep';
  }

  /// Switch tab
  void selectTab(MedicineTab tab) {
    state = state.copyWith(selectedTab: tab, errorMessage: null);
  }

  /// Select date
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, errorMessage: null);
    fetchDailySchedule();
  }

  /// Add medicine
  void onAddMedicine() {
    AppRouter.router.push(AppRoutes.addMedicine);
  }

  void selectTaskForReview(String taskId) {
    final task = state.scanTasks.cast<ScanTask?>().firstWhere(
      (t) => t?.id == taskId,
      orElse: () => null,
    );

    if (task != null) {
      final medications =
          task.userMedications
              ?.map(
                (m) => {
                  'name': m.effectiveName != '-'
                      ? m.effectiveName
                      : 'medicine.preview.unknown'.tr(),
                  'genericName':
                      m.medication?.genericName ??
                      'medicine.preview.basic_medicine'.tr(),
                  'manufacturer': m.effectiveManufacturer != '-'
                      ? m.effectiveManufacturer
                      : null,
                  'dosage': m.medication?.dosage,
                  'id': m.id,
                  'frequency': m.frequency,
                  'schedules': m.schedules,
                  'stockCount': m.stockCount,
                  'unit': m.medication?.unit,
                },
              )
              .toList() ??
          [];

      state = state.copyWith(
        reviewMedications: medications,
        reviewImagePath: task.imagePath,
      );
    }
  }

  void clearReviewTask() {
    state = state.copyWith(reviewMedications: [], reviewImagePath: null);
  }

  /// Task management
  void addScanTask(ScanTask task) {
    state = state.copyWith(scanTasks: [task, ...state.scanTasks]);
  }

  void updateScanTask(
    String id,
    ScanStatus status, {
    String? errorMessage,
    List<UserMedication>? userMedications,
    String? newId,
  }) {
    _updateTask(
      id,
      status,
      errorMessage: errorMessage,
      userMedications: userMedications,
      newId: newId,
    );
  }

  void deleteScanTask(String id) async {
    try {
      state = state.copyWith(
        scanTasks: state.scanTasks.where((t) => t.id != id).toList(),
      );

      if (!id.startsWith('temp_')) {
        await _repository.deleteScanTask(id);
      }
    } catch (e) {
      await fetchActiveMedications();
    }
  }

  void _updateTask(
    String id,
    ScanStatus status, {
    String? errorMessage,
    List<UserMedication>? userMedications,
    String? newId,
  }) {
    final updatedTasks = state.scanTasks.map((task) {
      if (task.id == id) {
        return ScanTask(
          id: newId ?? task.id,
          createdAt: task.createdAt,
          status: status,
          errorMessage: errorMessage ?? task.errorMessage,
          imagePath: task.imagePath,
          userMedications: userMedications ?? task.userMedications,
        );
      }
      return task;
    }).toList();
    state = state.copyWith(scanTasks: updatedTasks);
  }

  Future<void> fetchActiveMedications() async {
    state = state.copyWith(isLoading: true);
    try {
      // Parallel fetch
      final results = await Future.wait([
        _getUserMedications(),
        _repository.getScanTasks(),
      ]);

      final medications = results[0] as List<UserMedication>;
      final serverTasks = results[1] as List<ScanTask>;

      final active = medications.where((m) => m.isActive).toList();
      final inactive = medications.where((m) => !m.isActive).toList();

      final mergedTasks = serverTasks.map((serverTask) {
        final localTask = state.scanTasks.cast<ScanTask?>().firstWhere(
          (t) => t?.id == serverTask.id,
          orElse: () => null,
        );

        if (localTask != null &&
            localTask.imagePath != null &&
            serverTask.imagePath == null) {
          return serverTask.copyWith(imagePath: localTask.imagePath);
        }
        return serverTask;
      }).toList();

      final processingTasks = state.scanTasks
          .where((t) => t.status == ScanStatus.processing)
          .where((t) => !mergedTasks.any((st) => st.id == t.id))
          .toList();

      state = state.copyWith(
        activeMedications: active,
        inactiveMedications: inactive,
        scanTasks: [...processingTasks, ...mergedTasks],
        isLoading: false,
        isInitialLoad: false,
      );

      await fetchDailySchedule();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchDailySchedule() async {
    state = state.copyWith(errorMessage: null);
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);
      final schedule = await _getDailySchedule(dateStr);
      state = state.copyWith(dailySchedule: schedule);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Medicine Options Logic
  void onShowMedicineOptions(BuildContext context, UserMedication medication) {
    context.push(AppRoutes.medicineOptions, extra: medication);
  }

  void onShowQuantityPopup(BuildContext context, UserMedication medication) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Quantity',
      barrierColor: Colors.black.withValues(alpha: 0.1),
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
                child: MedicineQuantityPopup(
                  medication: medication,
                  onSave: (newQuantity) {
                    Navigator.pop(context);
                    onUpdateMedicineQuantity(medication, newQuantity);
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

  void onUpdateMedicineQuantity(UserMedication medication, int newQuantity) {
    // Optimistic update
    final updatedActive = state.activeMedications.map((m) {
      if (m.id == medication.id) {
        return m.copyWith(stockCount: newQuantity);
      }
      return m;
    }).toList();

    state = state.copyWith(activeMedications: updatedActive);

    // Call API
    try {
      _updateUserMedication(id: medication.id, stockCount: newQuantity);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> onEditMedicineDetails(UserMedication medication) async {
    await AppRouter.router.push(
      AppRoutes.medicineDetailPreviewEdit,
      extra: {
        'id': medication.id,
        'isUpdate': true,
        'name': medication.effectiveName,
        'manufacturer': medication.effectiveManufacturer,
        'dosage': medication.medication?.dosage,
        'genericName': medication.condition != null
            ? 'medicine.condition.${medication.condition!.slug}'.tr()
            : (medication.conditionCustom ??
                  medication.medication?.genericName),
        'medicationId': medication.medicationId,
        'mealInstruction': medication.mealInstruction,
        'conditionId': medication.conditionId,
        'conditionCustom': medication.conditionCustom,
      },
    );
  }

  void onChangeMedicineSchedule(UserMedication medication) {
    final List<Map<String, dynamic>> scheduleList =
        medication.reminderSchedules?.map((s) {
          final map = s as Map<String, dynamic>;
          return {
            'time': map['remindTime'] ?? map['time'],
            'quantity': map['quantity'] ?? 1,
          };
        }).toList() ??
        [];

    AppRouter.router.push(
      AppRoutes.medicineReminderEdit,
      extra: {
        'id': medication.id,
        'isUpdate': true,
        'startDate': medication.startDate,
        'endDate': medication.endDate,
        'frequency': medication.frequency ?? 'daily',
        'reminderEnabled': medication.reminderEnabled,
        'schedules': scheduleList,
      },
    );
  }

  void onStopMedication(BuildContext context, UserMedication medication) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Stop Medication Confirmation',
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
                child: StopMedicationPopup(
                  onConfirm: () {
                    // Update the medication to be inactive
                    onUpdateMedicineStatus(medication, false);
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

  void onUpdateMedicineStatus(UserMedication medication, bool isActive) {
    // Optimistic update
    final updatedActive = state.activeMedications
        .where((m) => m.id != medication.id)
        .toList();
    final updatedInactive = [
      ...state.inactiveMedications,
      medication.copyWith(isActive: isActive),
    ];

    if (!isActive) {
      state = state.copyWith(
        activeMedications: updatedActive,
        inactiveMedications: updatedInactive,
      );
    } else {
      // Implement reverse if needed
    }

    // Call API
    try {
      _updateUserMedication(id: medication.id, isActive: isActive);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> recordMedicationLog({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
  }) async {
    try {
      await _recordMedicationLog(
        userMedicationId: userMedicationId,
        reminderScheduleId: reminderScheduleId,
        status: status,
        actualQuantity: actualQuantity,
        actualAt: actualAt,
      );
      await fetchDailySchedule();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void onTakeMedication({
    required DailyScheduleItem item,
    int? quantity,
    String? selectedTime,
  }) {
    final date = state.selectedDate;
    final parts = (selectedTime ?? item.remindTime ?? '08:00').split(':');
    final takenDate = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    final finalQuantity = quantity ?? item.quantity ?? 1;

    if (item.logId != null) {
      updateMedicationLog(
        id: item.logId!,
        status: 'taken',
        actualQuantity: finalQuantity,
        actualAt: takenDate,
      );
    } else {
      recordMedicationLog(
        userMedicationId: item.userMedicationId,
        reminderScheduleId: item.reminderScheduleId,
        status: 'taken',
        actualQuantity: finalQuantity,
        actualAt: takenDate,
      );
    }
  }

  void onMissMedication({required DailyScheduleItem item, int? quantity}) {
    final finalQuantity = quantity ?? item.quantity ?? 1;

    if (item.logId != null) {
      updateMedicationLog(
        id: item.logId!,
        status: 'missed',
        actualQuantity: finalQuantity,
      );
    } else {
      recordMedicationLog(
        userMedicationId: item.userMedicationId,
        reminderScheduleId: item.reminderScheduleId,
        status: 'missed',
        actualQuantity: finalQuantity,
      );
    }
  }

  void onChangeStatus(DailyScheduleItem item) {
    final isTaken = item.status.toLowerCase() == 'taken';
    if (isTaken) {
      onMissMedication(item: item);
    } else {
      onTakeMedication(item: item, selectedTime: item.remindTime);
    }
  }

  Future<void> updateMedicationLog({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
  }) async {
    try {
      await _updateMedicationLog(
        id: id,
        status: status,
        actualQuantity: actualQuantity,
        actualAt: actualAt,
      );
      await fetchDailySchedule();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
