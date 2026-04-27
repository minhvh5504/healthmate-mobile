class NotificationEntity {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final String iconType;
  final String? actionUrl;
  final DateTime scheduledFor;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? sentAt;
  final String deliveryStatus;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.iconType,
    this.actionUrl,
    required this.scheduledFor,
    required this.isRead,
    this.readAt,
    this.sentAt,
    required this.deliveryStatus,
  });

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    String? iconType,
    String? actionUrl,
    DateTime? scheduledFor,
    bool? isRead,
    DateTime? readAt,
    DateTime? sentAt,
    String? deliveryStatus,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      iconType: iconType ?? this.iconType,
      actionUrl: actionUrl ?? this.actionUrl,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      sentAt: sentAt ?? this.sentAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }
}
