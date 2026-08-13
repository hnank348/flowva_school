class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String type;
  final List<String> data;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id:        json['id'] as int,
      userId:    json['user_id'] as int? ?? 0,
      title:     json['title'] ?? '',
      body:      json['body'] ?? '',
      type:      json['type'] ?? 'General',
      data:      (json['data'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isRead:    json['is_read'] == true,
      readAt:    json['read_at'],
      createdAt: json['created_at'] ?? '',
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      data: data,
      isRead: isRead ?? this.isRead,
      readAt: readAt,
      createdAt: createdAt,
    );
  }
}