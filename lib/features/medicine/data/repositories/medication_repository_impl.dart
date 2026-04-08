import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_datasource.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;

  MedicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Medication>> searchMedications(String query) {
    return remoteDataSource.searchMedications(query);
  }
}
