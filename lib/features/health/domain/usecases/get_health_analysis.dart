import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';

class GetHealthAnalysis {
  final HealthRepository repository;

  GetHealthAnalysis(this.repository);

  Future<HealthAnalysis> call() {
    return repository.getHealthAnalysis();
  }
}
