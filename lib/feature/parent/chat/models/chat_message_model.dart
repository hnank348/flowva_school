class ChatMessageModel {
  final String id;
  final String text;
  final String timeLabel;
  final bool isSent;
  final bool isRead;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.timeLabel,
    this.isSent = false,
    this.isRead = false,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    String? timeLabel,
    bool? isSent,
    bool? isRead,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      timeLabel: timeLabel ?? this.timeLabel,
      isSent: isSent ?? this.isSent,
      isRead: isRead ?? this.isRead,
    );
  }
}