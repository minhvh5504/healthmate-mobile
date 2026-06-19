import '../repositories/prescription_repository.dart';

class DeletePrescription {
  final PrescriptionRepository repository;
  DeletePrescription(this.repository);

  Future<void> call(String id) => repository.deletePrescription(id);
}
