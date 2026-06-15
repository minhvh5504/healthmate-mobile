import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/user_profile_model.dart';
import '../models/notification_time_slots_response.dart';
import '../models/user_relationship_response.dart';

part 'settings_api.g.dart';

@RestApi()
abstract class SettingsApi {
  factory SettingsApi(Dio dio) = _SettingsApi;

  @GET('profile')
  Future<UserProfileModel> getProfile();

  @PATCH('profile')
  Future<UserProfileModel> updateProfile(@Body() Map<String, dynamic> body);

  @MultiPart()
  @POST('upload/avatar')
  Future<dynamic> uploadAvatar(@Part(name: 'file') File file);

  @POST('auth/change-password')
  Future<void> changePassword(@Body() Map<String, dynamic> body);

  @GET('notification-time-slots')
  Future<NotificationTimeSlotsResponse> getNotificationTimeSlots();

  @GET('user-relationships')
  Future<UserRelationshipResponse> getUserRelationships();

  @POST('user-relationships/invite')
  Future<HttpResponse<dynamic>> inviteMember(@Body() Map<String, dynamic> body);

  @PATCH('user-relationships/{id}/accept')
  Future<void> acceptInvitation(@Path('id') String id);

  @DELETE('user-relationships/{id}')
  Future<void> removeRelationship(@Path('id') String id);

  @POST('user-relationships/accept-by-token')
  Future<void> acceptInvitationByToken(@Body() Map<String, dynamic> body);
}
