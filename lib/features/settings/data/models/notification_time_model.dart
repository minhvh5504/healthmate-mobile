import '../../domain/entities/notification_time.dart';

class NotificationTimeModel extends NotificationTime {
  const NotificationTimeModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.time,
    required super.iconPath,
  });

  factory NotificationTimeModel.fromJson(Map<String, dynamic> json) {
    return NotificationTimeModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['displayName'] as String? ?? '',
      time: json['defaultTime'] as String? ?? '',
      iconPath: json['iconPath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'displayName': title,
      'defaultTime': time,
      'iconPath': iconPath,
    };
  }

  static List<NotificationTimeModel> fromJsonList(List<dynamic> json) {
    return json
        .map((e) => NotificationTimeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
