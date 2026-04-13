import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/medication_api.dart';
import '../../../data/datasources/medication_remote_datasource.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../../../domain/repositories/medication_repository.dart';
import '../../../domain/usecases/get_user_medications.dart';
import '../../../domain/usecases/update_user_medication.dart';
import '../../../domain/usecases/create_user_medication.dart';
import 'medicine_notifier.dart';

export '../../../domain/repositories/medication_repository.dart';
export '../../../data/repositories/medication_repository_impl.dart';
export '../../../domain/usecases/get_user_medications.dart';
export '../../../domain/usecases/update_user_medication.dart';
export '../../../domain/usecases/create_user_medication.dart';
export 'medicine_notifier.dart';

/// Api Provider
final medicationApiProvider = Provider<MedicationApi>((ref) {
  return ApiClient(ref).create(MedicationApi.new);
});

/// Data Source Provider
final medicationRemoteDataSourceProvider = Provider<MedicationRemoteDataSource>((ref) {
  return MedicationRemoteDataSource(ref.read(medicationApiProvider));
});

/// Repository Provider
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepositoryImpl(
    remoteDataSource: ref.read(medicationRemoteDataSourceProvider),
  );
});

/// Core UseCase Providers
final getUserMedicationsUseCaseProvider = Provider<GetUserMedications>((ref) {
  return GetUserMedications(ref.read(medicationRepositoryProvider));
});

final updateUserMedicationUseCaseProvider = Provider<UpdateUserMedication>((ref) {
  return UpdateUserMedication(ref.read(medicationRepositoryProvider));
});

final createUserMedicationUseCaseProvider = Provider<CreateUserMedication>((ref) {
  return CreateUserMedication(ref.read(medicationRepositoryProvider));
});


/// Global [StateNotifierProvider] for the Medicine screen.
final medicineProvider = StateNotifierProvider<MedicineNotifier, MedicineState>(
  (ref) => MedicineNotifier(
    ref: ref,
    repository: ref.read(medicationRepositoryProvider),
    getUserMedications: ref.read(getUserMedicationsUseCaseProvider),
    createUserMedication: ref.read(createUserMedicationUseCaseProvider),
  ),
);
