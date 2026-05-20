class Message {
  final String id;
  final String sender;
  final String content;
  final String time;
  final bool isMe;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.time,
    required this.isMe,
  });
}
