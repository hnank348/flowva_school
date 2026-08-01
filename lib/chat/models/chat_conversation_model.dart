class ChatConversationModel {
  final String id;
  final String peerName;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final bool isOnline;
  final String? avatarUrl;

  const ChatConversationModel({
    required this.id,
    required this.peerName,
    required this.lastMessage,
    required this.timeLabel,
    this.unreadCount = 0,
    this.isOnline = false,
    this.avatarUrl,
  });

  bool get hasUnread => unreadCount > 0;

  ChatConversationModel copyWith({
    String? id,
    String? peerName,
    String? lastMessage,
    String? timeLabel,
    int? unreadCount,
    bool? isOnline,
    String? avatarUrl,
  }) {
    return ChatConversationModel(
      id: id ?? this.id,
      peerName: peerName ?? this.peerName,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}