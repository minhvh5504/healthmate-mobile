class NotificationTime {
  final String id;
  final String title;
  final String time;
  final String iconPath;

  const NotificationTime({
    required this.id,
    required this.title,
    required this.time,
    required this.iconPath,
  });

  NotificationTime copyWith({
    String? id,
    String? title,
    String? time,
    String? iconPath,
  }) {
    return NotificationTime(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
