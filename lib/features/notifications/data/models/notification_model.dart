import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.body,
    required super.iconType,
    super.actionUrl,
    required super.scheduledFor,
    required super.isRead,
    super.readAt,
    super.sentAt,
    required super.deliveryStatus,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      iconType: json['iconType'] as String,
      actionUrl: json['actionUrl'] as String?,
      scheduledFor: DateTime.parse(json['scheduledFor'] as String).toLocal(),
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String).toLocal() : null,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt'] as String).toLocal() : null,
      deliveryStatus: json['deliveryStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'iconType': iconType,
      'actionUrl': actionUrl,
      'scheduledFor': scheduledFor.toIso8601String(),
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'deliveryStatus': deliveryStatus,
    };
  }
}
