import '../models/chat_conversation_model.dart';

abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<ChatConversationModel> conversations;
  final String searchQuery;

  MessagesLoaded({
    required this.conversations,
    required this.searchQuery,
  });

  List<ChatConversationModel> get visibleConversations {
    final query = searchQuery.trim();
    if (query.isEmpty) return conversations;
    return conversations
        .where((c) => c.peerName.contains(query) || c.lastMessage.contains(query))
        .toList();
  }
}