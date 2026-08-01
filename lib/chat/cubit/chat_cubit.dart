import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';
import '../models/chat_message_model.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState(messages: [], hasDraft: false));

  void loadMessages() {
    final initialMessages = const [
      ChatMessageModel(
        id: 'm1',
        text: 'مرحباً، هل غادرت الحافلة المدرسة؟',
        timeLabel: '02:15 م',
        isSent: true,
        isRead: true,
      ),
      ChatMessageModel(
        id: 'm2',
        text: 'أهلاً بكِ، نعم تحركنا قبل دقيقتين ونحن في الطريق.',
        timeLabel: '02:16 م',
        isSent: false,
      ),
    ];
    emit(ChatState(messages: initialMessages, hasDraft: false));
  }

  void updateDraftStatus(String text) {
    emit(state.copyWith(hasDraft: text.trim().isNotEmpty));
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeLabel = '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'م' : 'ص'}';

    final newMessage = ChatMessageModel(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      timeLabel: timeLabel,
      isSent: true,
      isRead: false,
    );

    final updatedMessages = List<ChatMessageModel>.from(state.messages)..add(newMessage);
    emit(state.copyWith(messages: updatedMessages, hasDraft: false));
  }
}