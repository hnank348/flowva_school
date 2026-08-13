import '../models/chat_message_model.dart';

class ChatState {
  final List<ChatMessageModel> messages;
  final bool hasDraft;

  const ChatState({
    required this.messages,
    required this.hasDraft,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? hasDraft,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      hasDraft: hasDraft ?? this.hasDraft,
    );
  }
}