import 'package:dio/dio.dart';
import 'package:healthmate_mobile/features/health/data/models/health_analysis_model.dart';
import 'package:healthmate_mobile/features/health/data/models/health_history_change_model.dart';
import 'package:healthmate_mobile/features/health/data/models/health_history_model.dart';
import 'package:healthmate_mobile/features/health/data/models/user_profile_model.dart';
import 'package:retrofit/retrofit.dart';

part 'health_api.g.dart';

@RestApi()
abstract class HealthApi {
  factory HealthApi(Dio dio) = _HealthApi;

  @GET('profile')
  Future<UserProfileModel> getProfile();

  @PATCH('profile')
  Future<UserProfileModel> updateProfile(@Body() Map<String, dynamic> body);

  @GET('profile/health-analysis')
  Future<HealthAnalysisModel> getHealthAnalysis();

  @GET('profile/health-history')
  Future<HealthHistoryModel> getHealthHistory(
    @Query('metric') String metric,
    @Query('period') String period,
    @Query('date') String? date,
  );

  @GET('profile/health-history/changes')
  Future<HealthHistoryChangesModel> getHealthHistoryChanges(
    @Query('metric') String metric,
    @Query('period') String period,
    @Query('date') String? date,
  );
}
