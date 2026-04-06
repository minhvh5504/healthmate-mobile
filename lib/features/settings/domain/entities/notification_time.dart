class NotificationTime {
  final String id;
  final String slug;
  final String title;
  final String time;
  final String iconPath;

  const NotificationTime({
    required this.id,
    required this.slug,
    required this.title,
    required this.time,
    required this.iconPath,
  });

  NotificationTime copyWith({
    String? id,
    String? slug,
    String? title,
    String? time,
    String? iconPath,
  }) {
    return NotificationTime(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      time: time ?? this.time,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
