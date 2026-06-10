import '../api/medication_api.dart';
import '../models/medication_model.dart';
import '../models/user_medication_model.dart';
import '../models/scan_task_model.dart';
import '../models/medication_condition_model.dart';
import '../../domain/entities/medication_condition.dart';
import '../models/daily_schedule_model.dart';
import '../models/family_member_model.dart';

class MedicationRemoteDataSource {
  final MedicationApi api;

  MedicationRemoteDataSource(this.api);

  Future<List<MedicationModel>> searchMedications(String query) async {
    final response = await api.searchMedications(query);
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['data'] ?? [];
    return data.map((json) => MedicationModel.fromJson(json)).toList();
  }

  Future<ScanTaskModel> scan({
    required String scannedText,
    String? shape,
    Map<String, dynamic>? rawData,
  }) async {
    try {
      final response = await api.scan({
        'scannedText': scannedText,
        if (shape != null) 'shape': shape,
        if (rawData != null) 'rawScannedData': rawData,
      });

      if (response == null || response is! Map) {
        throw Exception('Invalid scan response');
      }

      final dataMap = response as Map<String, dynamic>;
      final dynamic data = dataMap['data'];

      if (data == null) throw Exception('No data in scan response');
      return ScanTaskModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ScanTaskModel>> getScanTasks() async {
    final response = await api.getScanTasks();
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['data'] ?? [];
    return data.map((json) => ScanTaskModel.fromJson(json)).toList();
  }

  Future<void> deleteScanTask(String id) async {
    await api.deleteScanTask(id);
  }

  Future<void> createUserMedication({
    String? medicationId,
    Map<String, dynamic>? scannedData,
    Map<String, dynamic>? data,
  }) async {
    await api.createUserMedication({
      if (medicationId != null && medicationId.isNotEmpty)
        'medicationId': medicationId,
      if (scannedData != null) 'scannedData': scannedData,
      if (data != null) ...data,
    });
  }

  Future<void> updateUserMedication({
    required String id,
    Map<String, dynamic>? data,
  }) async {
    await api.updateUserMedication(id, data ?? {});
  }

  Future<List<UserMedicationModel>> getUserMedications() async {
    final response = await api.getUserMedications();
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['data'] ?? [];
    return data.map((json) => UserMedicationModel.fromJson(json)).toList();
  }

  Future<List<MedicationCondition>> getMedicationConditions() async {
    final response = await api.getMedicationConditions();
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['data'] ?? [];
    return data.map((json) => MedicationConditionModel.fromJson(json)).toList();
  }

  Future<DailyScheduleModel> getDailySchedule(String date) async {
    final response = await api.getDailySchedule(date);
    final dataMap = response as Map<String, dynamic>;
    final data = dataMap['data'] as Map<String, dynamic>;
    return DailyScheduleModel.fromJson(data);
  }

  Future<void> createMedicationLog({
    required String userMedicationId,
    String? reminderScheduleId,
    required String status,
    int? actualQuantity,
    DateTime? actualAt,
  }) async {
    await api.createMedicationLog({
      'userMedicationId': userMedicationId,
      if (reminderScheduleId != null) 'reminderScheduleId': reminderScheduleId,
      'status': status,
      if (actualQuantity != null) 'actualQuantity': actualQuantity,
      if (actualAt != null) 'actualAt': actualAt.toUtc().toIso8601String(),
    });
  }

  Future<void> updateMedicationLog({
    required String id,
    String? status,
    int? actualQuantity,
    DateTime? actualAt,
  }) async {
    await api.updateMedicationLog(id, {
      if (status != null) 'status': status,
      if (actualQuantity != null) 'actualQuantity': actualQuantity,
      if (actualAt != null) 'actualAt': actualAt.toUtc().toIso8601String(),
    });
  }

  Future<List<FamilyMemberModel>> getUserRelationships() async {
    final response = await api.getUserRelationships();
    return response.data;
  }
}
