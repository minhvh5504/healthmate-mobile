import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'medication_api.g.dart';

@RestApi()
abstract class MedicationApi {
  factory MedicationApi(Dio dio) = _MedicationApi;

  @GET('medication/search')
  Future<dynamic> searchMedications(@Query('q') String query);

  @POST('user-medication/scan')
  Future<dynamic> scan(@Body() Map<String, dynamic> body);

  @POST('user-medication')
  Future<dynamic> createUserMedication(@Body() Map<String, dynamic> body);

  @PATCH('user-medication/{id}')
  Future<dynamic> updateUserMedication(@Path('id') String id, @Body() Map<String, dynamic> body);

  @GET('user-medication/scan-tasks')
  Future<dynamic> getScanTasks();

  @DELETE('user-medication/scan-tasks/{id}')
  Future<dynamic> deleteScanTask(@Path('id') String id);

  @GET('user-medication')
  Future<dynamic> getUserMedications();
}
