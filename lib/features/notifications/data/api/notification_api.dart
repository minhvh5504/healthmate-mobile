import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio) = _NotificationApi;

  @GET('notifications')
  Future<dynamic> getNotifications({
    @Query('isRead') bool? isRead,
    @Query('type') String? type,
    @Query('search') String? search,
    @Query('limit') int? limit,
    @Query('page') int? page,
  });

  @PATCH('notifications/{id}/read')
  Future<void> markAsRead(@Path('id') String id);

  @PATCH('notifications/mark-read')
  Future<void> markReadBulk(@Body() Map<String, dynamic> body);

  @DELETE('notifications/{id}')
  Future<void> delete(@Path('id') String id);

  @DELETE('notifications/bulk')
  Future<void> deleteBulk(@Body() Map<String, dynamic> body);
}
