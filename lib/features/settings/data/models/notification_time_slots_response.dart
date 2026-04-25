import 'notification_time_model.dart';

class NotificationTimeSlotsResponse {
  final bool success;
  final String message;
  final List<NotificationTimeModel> data;

  NotificationTimeSlotsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationTimeSlotsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationTimeSlotsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
              .map((e) => NotificationTimeModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
