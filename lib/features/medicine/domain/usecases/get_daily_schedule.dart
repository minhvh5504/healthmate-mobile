import '../../domain/repositories/medication_repository.dart';
import '../../domain/entities/daily_schedule.dart';

class GetDailyScheduleUseCase {
  final MedicationRepository repository;

  GetDailyScheduleUseCase(this.repository);

  Future<DailySchedule> call(String date) {
    return repository.getDailySchedule(date);
  }
}
