import '../entities/prescription.dart';
import '../repositories/prescription_repository.dart';

class GetPrescriptions {
  final PrescriptionRepository repository;
  GetPrescriptions(this.repository);

  Future<List<Prescription>> call() => repository.getPrescriptions();
}
