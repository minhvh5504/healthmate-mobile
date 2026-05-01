import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/medication_api.dart';
import '../../../data/datasources/medication_remote_datasource.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../../../domain/repositories/medication_repository.dart';
import '../../../domain/usecases/get_user_medications.dart';
import '../../../domain/usecases/update_user_medication.dart';
import '../../../domain/usecases/get_daily_schedule.dart';
import '../../../domain/usecases/record_medication_log.dart';
import '../../../domain/usecases/update_medication_log.dart';
import '../../../domain/usecases/get_family_members.dart';
import 'medicine_notifier.dart';

export '../../../domain/repositories/medication_repository.dart';
export '../../../data/repositories/medication_repository_impl.dart';
export '../../../domain/usecases/get_user_medications.dart';
export '../../../domain/usecases/update_user_medication.dart';
export '../../../domain/usecases/get_medication_conditions.dart';
export '../../../domain/usecases/get_daily_schedule.dart';
export '../../../domain/usecases/record_medication_log.dart';
export 'medicine_notifier.dart';

/// Api Provider
final medicationApiProvider = Provider<MedicationApi>((ref) {
  return ApiClient(ref).create(MedicationApi.new);
});

/// Data Source Provider
final medicationRemoteDataSourceProvider = Provider<MedicationRemoteDataSource>(
  (ref) {
    return MedicationRemoteDataSource(ref.read(medicationApiProvider));
  },
);

/// Repository Provider
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepositoryImpl(
    remoteDataSource: ref.read(medicationRemoteDataSourceProvider),
  );
});

/// Usecase get user medications
final getUserMedicationsUseCaseProvider = Provider<GetUserMedications>((ref) {
  return GetUserMedications(ref.read(medicationRepositoryProvider));
});

/// Usecase update user medication
final updateUserMedicationUseCaseProvider = Provider<UpdateUserMedication>((
  ref,
) {
  return UpdateUserMedication(ref.read(medicationRepositoryProvider));
});

final getDailyScheduleUseCaseProvider = Provider<GetDailyScheduleUseCase>((
  ref,
) {
  return GetDailyScheduleUseCase(ref.read(medicationRepositoryProvider));
});

/// Usecase record medication log
final recordMedicationLogUseCaseProvider = Provider<RecordMedicationLog>((ref) {
  return RecordMedicationLog(ref.read(medicationRepositoryProvider));
});

/// Usecase update medication log
final updateMedicationLogUseCaseProvider = Provider<UpdateMedicationLog>((ref) {
  return UpdateMedicationLog(ref.read(medicationRepositoryProvider));
});

/// Usecase get family members (Medicine version)
final getFamilyMembersUseCaseProvider = Provider<GetFamilyMembers>((ref) {
  return GetFamilyMembers(ref.read(medicationRepositoryProvider));
});

/// Provider
final medicineProvider = StateNotifierProvider<MedicineNotifier, MedicineState>(
  (ref) => MedicineNotifier(
    ref,
    ref.read(medicationRepositoryProvider),
    ref.read(getUserMedicationsUseCaseProvider),
    ref.read(updateUserMedicationUseCaseProvider),
    ref.read(getDailyScheduleUseCaseProvider),
    ref.read(recordMedicationLogUseCaseProvider),
    ref.read(updateMedicationLogUseCaseProvider),
    ref.read(getFamilyMembersUseCaseProvider),
  ),
);
