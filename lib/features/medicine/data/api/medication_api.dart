import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'medication_api.g.dart';

@RestApi()
abstract class MedicationApi {
  factory MedicationApi(Dio dio) = _MedicationApi;

  @GET('medication/search')
  Future<dynamic> searchMedications(@Query('q') String query);
}
