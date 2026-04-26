import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/history_medication_log.dart';
import '../../../domain/usecases/get_history_logs.dart';

class HistoryState {
  final bool isLoading;
  final bool isInitialLoad;
  final String? errorMessage;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final double monthlyAdherence;
  final List<HistoryMedicationLog> dailyLogs;
  final List<HistoryMedicationLog> monthlyLogs; // Added for calendar markers

  HistoryState({
    this.isLoading = false,
    this.isInitialLoad = true,
    this.errorMessage,
    DateTime? selectedDate,
    DateTime? focusedMonth,
    this.monthlyAdherence = 0.0,
    this.dailyLogs = const [],
    this.monthlyLogs = const [],
  })  : selectedDate = selectedDate ?? DateTime.now(),
        focusedMonth = focusedMonth ?? DateTime.now();

  HistoryState copyWith({
    bool? isLoading,
    bool? isInitialLoad,
    String? errorMessage,
    DateTime? selectedDate,
    DateTime? focusedMonth,
    double? monthlyAdherence,
    List<HistoryMedicationLog>? dailyLogs,
    List<HistoryMedicationLog>? monthlyLogs,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
      errorMessage: errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      monthlyAdherence: monthlyAdherence ?? this.monthlyAdherence,
      dailyLogs: dailyLogs ?? this.dailyLogs,
      monthlyLogs: monthlyLogs ?? this.monthlyLogs,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  final Ref ref;
  final GetHistoryLogs _getHistoryLogs;

  HistoryNotifier(this.ref, this._getHistoryLogs) : super(HistoryState()) {
    init();
  }

  Future<void> init() async {
    await fetchLogsForDate(state.selectedDate, isInitial: true);
    await fetchMonthlyData(state.focusedMonth);
  }

  Future<void> fetchLogsForDate(DateTime date, {bool isInitial = false}) async {
    state = state.copyWith(
      isLoading: true,
      isInitialLoad: isInitial,
      selectedDate: date,
    );
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final logs = await _getHistoryLogs(date: dateStr, range: 'day');
      state = state.copyWith(isLoading: false, isInitialLoad: false, dailyLogs: logs);
    } catch (e) {
      state = state.copyWith(isLoading: false, isInitialLoad: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchMonthlyData(DateTime month) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(month);
      final logs = await _getHistoryLogs(date: dateStr, range: 'month');
      
      if (logs.isEmpty) {
        state = state.copyWith(monthlyAdherence: 0.0, monthlyLogs: []);
        return;
      }

      final takenCount = logs.where((l) => l.isTaken).length;
      final adherence = takenCount / logs.length;
      
      state = state.copyWith(
        monthlyAdherence: adherence,
        monthlyLogs: logs,
      );
    } catch (e) {
      debugPrint('Error fetching monthly data: $e');
    }
  }

  void selectDate(DateTime date) {
    if (date.year == state.selectedDate.year &&
        date.month == state.selectedDate.month &&
        date.day == state.selectedDate.day) {
      return;
    }
    fetchLogsForDate(date);
  }

  void changeFocusedMonth(DateTime month) {
    if (month.year == state.focusedMonth.year && month.month == state.focusedMonth.month) {
      return;
    }
    state = state.copyWith(focusedMonth: month);
    fetchMonthlyData(month);
  }
}
