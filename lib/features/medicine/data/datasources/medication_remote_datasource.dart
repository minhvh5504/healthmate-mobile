import '../api/medication_api.dart';
import '../models/medication_model.dart';

class MedicationRemoteDataSource {
  final MedicationApi api;

  MedicationRemoteDataSource(this.api);

  Future<List<MedicationModel>> searchMedications(String query) async {
    final response = await api.searchMedications(query);
    final dataMap = response as Map<String, dynamic>;
    final List<dynamic> data = dataMap['data'] ?? [];
    return data.map((json) => MedicationModel.fromJson(json)).toList();
  }
}
