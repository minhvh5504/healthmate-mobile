import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/record_medication_log.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/update_medication_log.dart';
import 'package:healthmate_mobile/features/medicine/domain/usecases/update_user_medication.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../pages/medicine/widgets/medicine_quantity_popup.dart';
import '../../pages/medicine_options/widgets/stop_medication_popup.dart';
import '../../pages/medicine_options/widgets/delete_medication_popup.dart';
import '../../pages/medicine/widgets/family_selection_bottom_sheet.dart';
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
import '../../../domain/usecases/get_family_members.dart';
import '../../../domain/entities/family_member.dart';

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
  final String? selectedFamilyMemberId;
  final List<FamilyMember> familyMembers;

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
    this.selectedFamilyMemberId,
    this.familyMembers = const [],
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
    String? selectedFamilyMemberId,
    List<FamilyMember>? familyMembers,
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
      selectedFamilyMemberId:
          selectedFamilyMemberId ?? this.selectedFamilyMemberId,
      familyMembers: familyMembers ?? this.familyMembers,
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
  final GetFamilyMembers _getFamilyMembers;

  MedicineNotifier(
    this.ref,
    this._repository,
    this._getUserMedications,
    this._updateUserMedication,
    this._getDailySchedule,
    this._recordMedicationLog,
    this._updateMedicationLog,
    this._getFamilyMembers,
  ) : super(MedicineState()) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn && next.accessToken != null) {
        if (previous?.isLoggedIn != true) {
          ref.read(userProfileProvider.notifier).fetchProfile();
          fetchActiveMedications();
          loadFamilyMembers();
        }
      }
    });
    final auth = ref.read(authProvider);
    if (auth.isLoggedIn && auth.accessToken != null) {
      ref.read(userProfileProvider.notifier).fetchProfile();
      fetchActiveMedications();
      loadFamilyMembers();
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
    // Clear schedule to show skeleton while fetching the new day's data.
    state = MedicineState(
      selectedTab: state.selectedTab,
      selectedDate: date,
      isLoading: state.isLoading,
      scanTasks: state.scanTasks,
      activeMedications: state.activeMedications,
      inactiveMedications: state.inactiveMedications,
      reviewMedications: state.reviewMedications,
      reviewImagePath: state.reviewImagePath,
      isInitialLoad: state.isInitialLoad,
      selectedFamilyMemberId: state.selectedFamilyMemberId,
      familyMembers: state.familyMembers,
    );
    fetchDailySchedule();
  }

  /// Select family member
  void selectFamilyMember(String? id) {
    state = state.copyWith(selectedFamilyMemberId: id);
    fetchActiveMedications();
  }

  /// Handle family selection from UI
  void onSelectFamilyMember(BuildContext context, String? id) {
    selectFamilyMember(id);
    Navigator.pop(context);
  }

  /// Load family members
  Future<void> loadFamilyMembers() async {
    try {
      final members = await _getFamilyMembers();
      if (!mounted) return;
      state = state.copyWith(familyMembers: members);
    } catch (e) {
      // Quietly fail or handle error
    }
  }

  /// Add medicine
  void onAddMedicine() {
    AppRouter.router.push(AppRoutes.addMedicine);
  }

  /// Show family selection bottom sheet
  void onShowFamilySelection(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Family Selection',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              const FamilySelectionBottomSheet(),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  void selectTaskForReview(String taskId) {
    final task = state.scanTasks.cast<ScanTask?>().firstWhere(
      (t) => t?.id == taskId,
      orElse: () => null,
    );

    if (task != null) {
      final isMatched = task.status == ScanStatus.success;
      final medications =
          task.userMedications
              ?.map(
                (m) => {
                  'name': isMatched
                      ? (m.medication?.name ??
                            (m.effectiveName != '-'
                                ? m.effectiveName
                                : 'medicine.preview.unknown'.tr()))
                      : (m.scannedData?['scannedText']?.toString() ??
                            (m.effectiveName != '-'
                                ? m.effectiveName
                                : 'medicine.preview.unknown'.tr())),
                  'genericName': isMatched
                      ? (m.medication?.genericName ??
                            'medicine.preview.basic_medicine'.tr())
                      : 'medicine.scan.no_results_found'.tr(),
                  'manufacturer': isMatched && m.effectiveManufacturer != '-'
                      ? m.effectiveManufacturer
                      : null,
                  'dosage': isMatched ? m.medication?.dosage : null,
                  'id': m.id,
                  'medicationId': isMatched ? m.medicationId : null,
                  'scannedData': m.scannedData,
                  'frequency': m.frequency,
                  'schedules': m.schedules,
                  'stockCount': m.stockCount,
                  'unit': isMatched ? m.medication?.unit : null,
                  'isMatched': isMatched,
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
    String? imagePath,
  }) {
    _updateTask(
      id,
      status,
      errorMessage: errorMessage,
      userMedications: userMedications,
      newId: newId,
      imagePath: imagePath,
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
    String? imagePath,
  }) {
    final updatedTasks = state.scanTasks.map((task) {
      if (task.id == id) {
        return ScanTask(
          id: newId ?? task.id,
          createdAt: task.createdAt,
          status: status,
          errorMessage: errorMessage ?? task.errorMessage,
          imagePath: imagePath ?? task.imagePath,
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

      if (!mounted) return;

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
      if (!mounted) return;
      AppToast.error(e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchDailySchedule() async {
    state = state.copyWith(errorMessage: null);
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);
      final schedule = await _getDailySchedule(dateStr);
      if (!mounted) return;
      state = state.copyWith(dailySchedule: schedule);
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e);
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
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
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
            'id': map['id'],
            'time': map['remindTime'] ?? map['time'],
            'quantity': map['quantity'] ?? 1,
          };
        }).toList() ??
        [];

    List<int>? selectedDays;
    if (medication.reminderSchedules != null &&
        medication.reminderSchedules!.isNotEmpty) {
      final firstSchedule = medication.reminderSchedules!.first;
      if (firstSchedule is Map) {
        final days =
            firstSchedule['repeatDays'] ?? firstSchedule['repeat_days'];
        if (days is List) {
          selectedDays = days
              .map((e) => int.tryParse(e.toString()))
              .whereType<int>()
              .toList();
        }
      }
    }

    AppRouter.router.push(
      AppRoutes.medicineReminderEdit,
      extra: {
        'id': medication.id,
        'isUpdate': true,
        'startDate': medication.startDate,
        'endDate': medication.endDate,
        'frequency': medication.frequency ?? 'daily',
        'selectedDays': selectedDays,
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      AppRouter.router.go(AppRoutes.medicine);
                    });
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
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  void onShowDeleteConfirmDialog(BuildContext context, UserMedication medication) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Delete Medication Confirmation',
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
                child: DeleteMedicationPopup(
                  onConfirm: () {
                    onDeleteMedication(medication);
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
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> onUpdateMedicineStatus(
    UserMedication medication,
    bool isActive,
  ) async {
    if (!isActive) {
      state = state.copyWith(
        activeMedications: state.activeMedications
            .where((m) => m.id != medication.id)
            .toList(),
        inactiveMedications: [
          ...state.inactiveMedications.where((m) => m.id != medication.id),
          medication.copyWith(isActive: false),
        ],
      );
    }

    try {
      await _updateUserMedication(id: medication.id, isActive: isActive);
      if (!mounted) return;
      await fetchActiveMedications();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e);
      await fetchActiveMedications();
    }
  }

  Future<void> onReactivateMedication(UserMedication medication) async {
    try {
      await _updateUserMedication(id: medication.id, isActive: true);
      if (!mounted) return;
      AppToast.success('medicine.activate_success'.tr());
      await fetchActiveMedications();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e);
    }
  }

  Future<void> onDeleteMedication(UserMedication medication) async {
    state = state.copyWith(
      activeMedications: state.activeMedications
          .where((m) => m.id != medication.id)
          .toList(),
      inactiveMedications: state.inactiveMedications
          .where((m) => m.id != medication.id)
          .toList(),
    );

    try {
      await _repository.deleteUserMedication(medication.id);
      if (!mounted) return;
      AppToast.success('medicine.delete_success'.tr());
      await fetchActiveMedications();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e);
      await fetchActiveMedications();
    }
  }

  Future<bool> recordMedicationLog({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
    String? mealInstruction,
  }) async {
    try {
      await _recordMedicationLog(
        userMedicationId: userMedicationId,
        reminderScheduleId: reminderScheduleId,
        status: status,
        actualQuantity: actualQuantity,
        actualAt: actualAt,
        mealInstruction: mealInstruction,
      );
      if (!mounted) return false;
      await fetchActiveMedications();
      return true;
    } catch (e) {
      if (!mounted) return false;
      AppToast.error(e);
      return false;
    }
  }

  DateTime _selectedDateWithTime(String? time) {
    final date = state.selectedDate;
    final parts = (time ?? '08:00').split(':');
    final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 8;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  UserMedication? _findMedicationForScheduleItem(DailyScheduleItem item) {
    for (final medication in [
      ...state.activeMedications,
      ...state.inactiveMedications,
    ]) {
      if (medication.id == item.userMedicationId) {
        return medication;
      }
    }
    return null;
  }

  bool _redirectToCabinetIfOutOfStock(DailyScheduleItem item) {
    final medication = _findMedicationForScheduleItem(item);
    final stockCount = medication?.stockCount;
    if (stockCount == null || stockCount > 0) {
      return false;
    }

    state = state.copyWith(selectedTab: MedicineTab.cabinet);
    AppToast.warning('medicine.stock.out_of_stock_log_blocked'.tr());
    return true;
  }

  Future<bool> onTakeMedication({
    required DailyScheduleItem item,
    int? quantity,
    String? selectedTime,
  }) async {
    if (_isFutureSelectedDate()) {
      AppToast.warning('medicine.log_status.future_locked'.tr());
      return false;
    }

    if (_redirectToCabinetIfOutOfStock(item)) {
      return false;
    }

    final takenDate = _selectedDateWithTime(selectedTime ?? item.remindTime);

    final finalQuantity = quantity ?? item.quantity ?? 1;

    if (item.logId != null) {
      return updateMedicationLog(
        id: item.logId!,
        status: 'taken',
        actualQuantity: finalQuantity,
        actualAt: takenDate,
        mealInstruction: item.mealInstruction,
      );
    } else {
      return recordMedicationLog(
        userMedicationId: item.userMedicationId,
        reminderScheduleId: item.reminderScheduleId,
        status: 'taken',
        actualQuantity: finalQuantity,
        actualAt: takenDate,
        mealInstruction: item.mealInstruction,
      );
    }
  }

  Future<bool> onMissMedication({
    required DailyScheduleItem item,
    int? quantity,
  }) async {
    if (_isFutureSelectedDate()) {
      AppToast.warning('medicine.log_status.future_locked'.tr());
      return false;
    }

    if (_redirectToCabinetIfOutOfStock(item)) {
      return false;
    }

    final finalQuantity = quantity ?? item.quantity ?? 1;
    final missedDate = _selectedDateWithTime(item.remindTime);

    if (item.logId != null) {
      return updateMedicationLog(
        id: item.logId!,
        status: 'missed',
        actualQuantity: finalQuantity,
        actualAt: missedDate,
        mealInstruction: item.mealInstruction,
      );
    } else {
      return recordMedicationLog(
        userMedicationId: item.userMedicationId,
        reminderScheduleId: item.reminderScheduleId,
        status: 'missed',
        actualQuantity: finalQuantity,
        actualAt: missedDate,
        mealInstruction: item.mealInstruction,
      );
    }
  }

  bool _isFutureSelectedDate() {
    final selected = state.selectedDate;
    final today = DateTime.now();
    final selectedDay = DateTime(selected.year, selected.month, selected.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return selectedDay.isAfter(todayOnly);
  }

  Future<bool> onChangeStatus(DailyScheduleItem item) {
    final isTaken = item.status.toLowerCase() == 'taken';
    if (isTaken) {
      return onMissMedication(item: item);
    }
    return onTakeMedication(item: item, selectedTime: item.remindTime);
  }

  Future<bool> updateMedicationLog({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
    String? mealInstruction,
  }) async {
    try {
      await _updateMedicationLog(
        id: id,
        status: status,
        actualQuantity: actualQuantity,
        actualAt: actualAt,
        mealInstruction: mealInstruction,
      );
      if (!mounted) return false;
      await fetchActiveMedications();
      return true;
    } catch (e) {
      if (!mounted) return false;
      AppToast.error(e);
      return false;
    }
  }
}
