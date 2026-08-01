import 'package:flutter_bloc/flutter_bloc.dart';
import 'messages_state.dart';
import '../models/chat_conversation_model.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  List<ChatConversationModel> _allConversations = [];

  void loadConversations() {
    emit(MessagesLoading());
    
    // بيانات وهمية مجهزة لتطابق التصاميم وتسهل الربط لاحقاً
    _allConversations = const [
      ChatConversationModel(
        id: '1',
        peerName: 'كابتن أحمد المندوب',
        lastMessage: 'أنا عند الباب الرئيسي للمدرسة حالياً.',
        timeLabel: '10:30 ص',
        unreadCount: 2,
        isOnline: true,
      ),
      ChatConversationModel(
        id: '2',
        peerName: 'أ. سارة (مشرفة الباص)',
        lastMessage: 'تم صعود الطلاب وتتحرك الحافلة الآن.',
        timeLabel: 'أمس',
        unreadCount: 0,
        isOnline: false,
      ),
    ];

    emit(MessagesLoaded(conversations: _allConversations, searchQuery: ''));
  }

  void updateSearchQuery(String query) {
    if (state is MessagesLoaded) {
      emit(MessagesLoaded(conversations: _allConversations, searchQuery: query));
    }
  }
}