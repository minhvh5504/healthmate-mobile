import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicineFlowState {
  final String? name;
  final String? manufacturer;
  final String? genericName;
  final String? strength;
  final String? medicationId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? frequency;
  final List<int> selectedDays;
  final List<Map<String, dynamic>> schedules;
  final bool reminderEnabled;
  final bool isLoading;
  final String? error;
  final int stockCount;
  final int lowStockThreshold;
  final bool lowStockReminderEnabled;
  final Map<String, dynamic>? scannedData;
  final String? conditionId;
  final String? conditionCustom;

  MedicineFlowState({
    this.name,
    this.manufacturer,
    this.genericName,
    this.strength,
    this.medicationId,
    this.startDate,
    this.endDate,
    this.frequency,
    this.selectedDays = const [],
    this.schedules = const [],
    this.reminderEnabled = true,
    this.isLoading = false,
    this.error,
    this.stockCount = 30,
    this.lowStockThreshold = 5,
    this.lowStockReminderEnabled = true,
    this.scannedData,
    this.conditionId,
    this.conditionCustom,
  });

  MedicineFlowState copyWith({
    String? name,
    String? manufacturer,
    String? genericName,
    String? strength,
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
    String? frequency,
    List<int>? selectedDays,
    List<Map<String, dynamic>>? schedules,
    bool? reminderEnabled,
    bool? isLoading,
    String? error,
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
    Map<String, dynamic>? scannedData,
    String? conditionId,
    String? conditionCustom,
  }) {
    return MedicineFlowState(
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      genericName: genericName ?? this.genericName,
      strength: strength ?? this.strength,
      medicationId: medicationId ?? this.medicationId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      schedules: schedules ?? this.schedules,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      stockCount: stockCount ?? this.stockCount,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      lowStockReminderEnabled:
          lowStockReminderEnabled ?? this.lowStockReminderEnabled,
      scannedData: scannedData ?? this.scannedData,
      conditionId: conditionId ?? this.conditionId,
      conditionCustom: conditionCustom ?? this.conditionCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'manufacturer': manufacturer,
      'genericName': genericName,
      'strength': strength,
      'medicationId': medicationId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'frequency': frequency,
      'selectedDays': selectedDays,
      'schedules': schedules,
      'reminderEnabled': reminderEnabled,
      'stockCount': stockCount,
      'lowStockThreshold': lowStockThreshold,
      'lowStockReminderEnabled': lowStockReminderEnabled,
      'scannedData': scannedData,
      'conditionId': conditionId,
      'conditionCustom': conditionCustom,
    };
  }
}

class MedicineFlowNotifier extends StateNotifier<MedicineFlowState> {
  final Ref ref;

  MedicineFlowNotifier(this.ref) : super(MedicineFlowState());

  void init(Map<String, dynamic> initialData) {
    state = MedicineFlowState(
      name: initialData['name'],
      manufacturer: initialData['manufacturer'],
      genericName: initialData['genericName'],
      strength: initialData['strength'],
      medicationId: initialData['medicationId'],
      scannedData: initialData['scannedData'],
      conditionId: initialData['conditionId'],
      conditionCustom: initialData['conditionCustom'],
    );
  }

  void updateMedicineInfo({
    String? name,
    String? manufacturer,
    String? genericName,
    String? strength,
    String? medicationId,
  }) {
    state = state.copyWith(
      name: name,
      manufacturer: manufacturer,
      genericName: genericName,
      strength: strength,
      medicationId: medicationId,
    );
  }

  void updateCondition({
    String? conditionId,
    String? conditionCustom,
    String? genericName,
  }) {
    state = state.copyWith(
      conditionId: conditionId,
      conditionCustom: conditionCustom,
      genericName: genericName,
    );
  }

  void updateReminderConfig({
    DateTime? startDate,
    DateTime? endDate,
    String? frequency,
    List<int>? selectedDays,
    List<Map<String, dynamic>>? schedules,
    bool? reminderEnabled,
  }) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      frequency: frequency,
      selectedDays: selectedDays,
      schedules: schedules,
      reminderEnabled: reminderEnabled,
    );
  }

  void updateStock({
    int? stockCount,
    int? lowStockThreshold,
    bool? lowStockReminderEnabled,
  }) {
    state = state.copyWith(
      stockCount: stockCount ?? state.stockCount,
      lowStockThreshold: lowStockThreshold ?? state.lowStockThreshold,
      lowStockReminderEnabled:
          lowStockReminderEnabled ?? state.lowStockReminderEnabled,
    );
  }
}
