import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'history_api.g.dart';

@RestApi()
abstract class HistoryApi {
  factory HistoryApi(Dio dio) = _HistoryApi;

  @GET('medication-logs')
  Future<dynamic> getMedicationLogs({
    @Query('userMedicationId') String? userMedicationId,
    @Query('range') String? range,
    @Query('date') String? date,
  });
}
