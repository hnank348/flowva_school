enum NotificationType {
  absence,        // تنبيه غياب
  invoice,        // فاتورة مستحقة
  results,        // نتائج جديدة
  schoolEvent,    // حدث مدرسي
  busUpdate,      // تحديث الباص
  importantAlert  // إعلان مهم
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final NotificationType type;
  final String? studentName;
  final List<String> tags;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
    this.studentName,
    this.tags = const [],
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? time,
    bool? isRead,
    NotificationType? type,
    String? studentName,
    List<String>? tags,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      studentName: studentName ?? this.studentName,
      tags: tags ?? this.tags,
    );
  }
}