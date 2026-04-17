import '../api/medication_api.dart';
import '../models/medication_model.dart';
import '../models/user_medication_model.dart';
import '../models/scan_task_model.dart';
import '../models/medication_condition_model.dart';
import '../../domain/entities/medication_condition.dart';

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
    required String medicationId,
    Map<String, dynamic>? scannedData,
  }) async {
    await api.createUserMedication({
      'medicationId': medicationId,
      if (scannedData != null) 'scannedData': scannedData,
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
}
