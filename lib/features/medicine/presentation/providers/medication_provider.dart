import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/api/medication_api.dart';
import '../../data/datasources/medication_remote_datasource.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../domain/repositories/medication_repository.dart';

final medicationApiProvider = Provider<MedicationApi>((ref) {
  return ApiClient(ref).create(MedicationApi.new);
});

final medicationRemoteDataSourceProvider =
    Provider<MedicationRemoteDataSource>((ref) {
  return MedicationRemoteDataSource(ref.read(medicationApiProvider));
});

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepositoryImpl(
    remoteDataSource: ref.read(medicationRemoteDataSourceProvider),
  );
});
