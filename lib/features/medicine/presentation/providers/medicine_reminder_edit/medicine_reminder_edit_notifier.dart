import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/routing/app_router.dart';
import '../medicine/medicine_provider.dart';

class MedicineReminderEditState {
  final Map<String, dynamic> medication;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isEndDateEnabled;
  final String frequency;
  final List<int> selectedDays;
  final List<ScheduleDoseEdit> schedules;
  final bool reminderEnabled;
  final bool isLoading;
  final DateTime focusedDate;

  MedicineReminderEditState({
    this.medication = const {},
    required this.startDate,
    this.endDate,
    this.isEndDateEnabled = false,
    this.frequency = 'daily',
    this.selectedDays = const [1, 2, 3, 4, 5, 6, 7],
    this.schedules = const [],
    this.reminderEnabled = true,
    this.isLoading = false,
    required this.focusedDate,
  });

  MedicineReminderEditState copyWith({
    Map<String, dynamic>? medication,
    DateTime? startDate,
    DateTime? endDate,
    bool? isEndDateEnabled,
    String? frequency,
    List<int>? selectedDays,
    List<ScheduleDoseEdit>? schedules,
    bool? reminderEnabled,
    bool? isLoading,
    DateTime? focusedDate,
    bool clearEndDate = false,
  }) {
    return MedicineReminderEditState(
      medication: medication ?? this.medication,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      isEndDateEnabled: isEndDateEnabled ?? this.isEndDateEnabled,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      schedules: schedules ?? this.schedules,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isLoading: isLoading ?? this.isLoading,
      focusedDate: focusedDate ?? this.focusedDate,
    );
  }

  String getStartDateText() {
    final now = DateTime.now();
    if (startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day) {
      return 'medicine.reminder.today'.tr();
    }
    return DateFormat('dd/MM/yyyy').format(startDate);
  }

  String getEndDateText() {
    if (!isEndDateEnabled || endDate == null) {
      return 'medicine.reminder.none'.tr();
    }
    return DateFormat('dd/MM/yyyy').format(endDate!);
  }
}

class ScheduleDoseEdit {
  final String? id;
  final String time; // format "HH:mm"
  final int quantity;

  ScheduleDoseEdit({this.id, required this.time, required this.quantity});

  Map<String, dynamic> toPayload() => {
    if (id != null && id!.isNotEmpty) 'id': id,
    'time': time,
    'quantity': quantity,
  };
}

class MedicineReminderEditNotifier
    extends StateNotifier<MedicineReminderEditState> {
  final Ref ref;
  final UpdateUserMedication? _updateUserMedication;

  MedicineReminderEditNotifier(this.ref, this._updateUserMedication)
    : super(
        MedicineReminderEditState(
          startDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          focusedDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          schedules: [ScheduleDoseEdit(time: '08:00', quantity: 1)],
        ),
      );

  void init(Map<String, dynamic> medication) {
    DateTime? startDate;
    if (medication['startDate'] != null) {
      if (medication['startDate'] is DateTime) {
        startDate = medication['startDate'];
      } else {
        startDate = DateTime.tryParse(medication['startDate'].toString());
      }
    }

    DateTime? endDate;
    if (medication['endDate'] != null) {
      if (medication['endDate'] is DateTime) {
        endDate = medication['endDate'];
      } else {
        endDate = DateTime.tryParse(medication['endDate'].toString());
      }
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<ScheduleDoseEdit> initialSchedules = state.schedules;
    final rawSchedules = medication['schedules'];
    if (rawSchedules != null &&
        rawSchedules is List &&
        rawSchedules.isNotEmpty) {
      initialSchedules = rawSchedules
          .map(
            (s) => ScheduleDoseEdit(
              id: s['id']?.toString(),
              time: s['time']?.toString() ?? '08:00',
              quantity: (s['quantity'] is int)
                  ? s['quantity']
                  : (s['doses'] is int)
                  ? s['doses']
                  : int.tryParse(
                          s['quantity']?.toString() ??
                              s['doses']?.toString() ??
                              '1',
                        ) ??
                        1,
            ),
          )
          .toList();
    }

    final frequency = medication['frequency']?.toString() ?? 'daily';
    final isAsNeeded = frequency == 'as_needed';

    state = state.copyWith(
      medication: medication,
      startDate: startDate != null
          ? DateTime(startDate.year, startDate.month, startDate.day)
          : today,
      endDate: isAsNeeded || endDate == null
          ? null
          : DateTime(endDate.year, endDate.month, endDate.day),
      isEndDateEnabled: !isAsNeeded && endDate != null,
      focusedDate: startDate != null
          ? DateTime(startDate.year, startDate.month, startDate.day)
          : today,
      frequency: frequency,
      schedules: isAsNeeded ? const [] : initialSchedules,
      reminderEnabled: isAsNeeded
          ? false
          : medication['reminderEnabled'] as bool? ?? true,
      clearEndDate: isAsNeeded || endDate == null,
    );
  }

  void updateStartDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    state = state.copyWith(startDate: normalizedDate);
    if (state.isEndDateEnabled &&
        state.endDate != null &&
        state.endDate!.isBefore(normalizedDate)) {
      state = state.copyWith(endDate: normalizedDate);
    }
  }

  void updateEndDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    state = state.copyWith(endDate: normalizedDate);
  }

  void setFocusedDate(DateTime date) {
    state = state.copyWith(focusedDate: date);
  }

  void nextMonth() {
    state = state.copyWith(
      focusedDate: DateTime(
        state.focusedDate.year,
        state.focusedDate.month + 1,
      ),
    );
  }

  void previousMonth() {
    state = state.copyWith(
      focusedDate: DateTime(
        state.focusedDate.year,
        state.focusedDate.month - 1,
      ),
    );
  }

  void toggleEndDateEnabled(bool enabled) {
    DateTime? newEndDate;
    if (enabled) {
      newEndDate =
          state.endDate != null && !state.endDate!.isBefore(state.startDate)
          ? state.endDate
          : state.startDate.add(const Duration(days: 7));
    }

    state = state.copyWith(
      isEndDateEnabled: enabled,
      endDate: newEndDate,
      clearEndDate: !enabled,
    );
  }

  void updateFrequency(String frequency) {
    if (frequency == 'as_needed') {
      state = state.copyWith(
        frequency: frequency,
        isEndDateEnabled: false,
        clearEndDate: true,
      );
      return;
    }
    state = state.copyWith(frequency: frequency);
  }

  void updateFrequencyAndDays(String frequency, List<int> days) {
    if (frequency == 'as_needed') {
      state = state.copyWith(
        frequency: frequency,
        selectedDays: const [],
        isEndDateEnabled: false,
        clearEndDate: true,
      );
      return;
    }
    state = state.copyWith(frequency: frequency, selectedDays: days);
  }

  void toggleDay(int day) {
    final updated = List<int>.from(state.selectedDays);
    if (updated.contains(day)) {
      if (updated.length > 1) {
        updated.remove(day);
      }
    } else {
      updated.add(day);
      updated.sort();
    }
    state = state.copyWith(selectedDays: updated);
  }

  String getFrequencyText() {
    if (state.frequency == 'daily') return 'medicine.reminder.daily'.tr();
    if (state.frequency == 'as_needed') {
      return 'medicine.reminder.as_needed'.tr();
    }
    if (state.frequency == 'specific_days') {
      if (state.selectedDays.length == 7) return 'medicine.reminder.daily'.tr();
      return state.selectedDays
          .map((d) {
            switch (d) {
              case 1:
                return 'medicine.reminder.mon'.tr();
              case 2:
                return 'medicine.reminder.tue'.tr();
              case 3:
                return 'medicine.reminder.wed'.tr();
              case 4:
                return 'medicine.reminder.thu'.tr();
              case 5:
                return 'medicine.reminder.fri'.tr();
              case 6:
                return 'medicine.reminder.sat'.tr();
              case 7:
                return 'medicine.reminder.sun'.tr();
              default:
                return '';
            }
          })
          .join(', ');
    }
    return '';
  }

  void toggleReminder(bool enabled) {
    state = state.copyWith(reminderEnabled: enabled);
  }

  void addSchedule(String time, int quantity) {
    final updated = List<ScheduleDoseEdit>.from(state.schedules);
    updated.add(ScheduleDoseEdit(time: time, quantity: quantity));
    state = state.copyWith(schedules: updated);
  }

  void addDefaultSchedule() {
    addSchedule('08:00', 1);
  }

  void removeSchedule(int index) {
    final updated = List<ScheduleDoseEdit>.from(state.schedules);
    updated.removeAt(index);
    state = state.copyWith(schedules: updated);
  }

  void updateSchedule(int index, String? time, int? quantity) {
    final updated = List<ScheduleDoseEdit>.from(state.schedules);
    if (index >= 0 && index < updated.length) {
      updated[index] = ScheduleDoseEdit(
        id: updated[index].id,
        time: time ?? updated[index].time,
        quantity: quantity ?? updated[index].quantity,
      );
      state = state.copyWith(schedules: updated);
    }
  }

  void onBack() {
    AppRouter.router.pop();
  }

  Future<void> onSave() async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = state.medication['id'] as String?;
      if (userId != null && _updateUserMedication != null) {
        final isAsNeeded = state.frequency == 'as_needed';

        await _updateUserMedication.call(
          id: userId,
          startDate: DateTime.utc(
            state.startDate.year,
            state.startDate.month,
            state.startDate.day,
          ).toIso8601String(),
          endDate:
              !isAsNeeded && state.isEndDateEnabled && state.endDate != null
              ? DateTime.utc(
                  state.endDate!.year,
                  state.endDate!.month,
                  state.endDate!.day,
                ).toIso8601String()
              : null,
          frequency: state.frequency,
          selectedDays: isAsNeeded ? null : state.selectedDays,
          schedules: isAsNeeded
              ? const []
              : state.schedules.map((s) => s.toPayload()).toList(),
          reminderEnabled: isAsNeeded ? false : state.reminderEnabled,
        );
        await ref.read(medicineProvider.notifier).fetchActiveMedications();
      }

      AppRouter.router.pop();
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
