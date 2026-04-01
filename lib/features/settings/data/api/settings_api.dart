import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user_profile_model.dart';

part 'settings_api.g.dart';

@RestApi()
abstract class SettingsApi {
  factory SettingsApi(Dio dio) = _SettingsApi;

  @GET('auth/profile')
  Future<UserProfileModel> getProfile();
}
