import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/api/prescription_api.dart';
import '../../../data/datasources/prescription_remote_datasource.dart';
import '../../../data/repositories/prescription_repository_impl.dart';
import '../../../domain/repositories/prescription_repository.dart';
import '../../../domain/usecases/get_prescriptions.dart';
import '../../../domain/usecases/delete_prescription.dart';
import '../../../domain/usecases/create_prescription.dart';
import '../../../domain/usecases/update_prescription.dart';
import 'prescription_notifier.dart';

export '../../../domain/entities/prescription.dart';
export 'prescription_notifier.dart';

final prescriptionApiProvider = Provider<PrescriptionApi>((ref) {
  return ApiClient(ref).create(PrescriptionApi.new);
});

final prescriptionDataSourceProvider = Provider<PrescriptionRemoteDataSource>((
  ref,
) {
  return PrescriptionRemoteDataSource(ref.read(prescriptionApiProvider));
});

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepositoryImpl(
    remoteDataSource: ref.read(prescriptionDataSourceProvider),
  );
});

final getPrescriptionsProvider = Provider<GetPrescriptions>((ref) {
  return GetPrescriptions(ref.read(prescriptionRepositoryProvider));
});

final deletePrescriptionProvider = Provider<DeletePrescription>((ref) {
  return DeletePrescription(ref.read(prescriptionRepositoryProvider));
});

final createPrescriptionProvider = Provider<CreatePrescription>((ref) {
  return CreatePrescription(ref.read(prescriptionRepositoryProvider));
});

final updatePrescriptionProvider = Provider<UpdatePrescription>((ref) {
  return UpdatePrescription(ref.read(prescriptionRepositoryProvider));
});

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, PrescriptionState>(
      (ref) => PrescriptionNotifier(
        ref.read(getPrescriptionsProvider),
        ref.read(deletePrescriptionProvider),
      ),
    );
