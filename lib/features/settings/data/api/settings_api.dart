import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user_profile_model.dart';
import '../models/notification_time_model.dart';

part 'settings_api.g.dart';

@RestApi()
abstract class SettingsApi {
  factory SettingsApi(Dio dio) = _SettingsApi;

  @GET('auth/profile')
  Future<UserProfileModel> getProfile();

  @POST('auth/change-password')
  Future<void> changePassword(@Body() Map<String, dynamic> body);

  @GET('notification-time-slots')
  Future<List<NotificationTimeModel>> getNotificationTimeSlots();

  @PATCH('notification-time-slots/{id}')
  Future<NotificationTimeModel> updateNotificationTimeSlot(
      @Path('id') String id, @Body() Map<String, dynamic> body);
}
