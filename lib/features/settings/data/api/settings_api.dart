import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user_profile_model.dart';
import '../models/notification_time_model.dart';

part 'settings_api.g.dart';

@RestApi()
abstract class SettingsApi {
  factory SettingsApi(Dio dio) = _SettingsApi;

  @GET('profile')
  Future<UserProfileModel> getProfile();

  @PATCH('profile')
  Future<UserProfileModel> updateProfile(@Body() Map<String, dynamic> body);

  @POST('auth/change-password')
  Future<void> changePassword(@Body() Map<String, dynamic> body);

  @GET('notification-time-slots')
  Future<List<NotificationTimeModel>> getNotificationTimeSlots();
}
