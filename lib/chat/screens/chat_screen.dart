import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../models/chat_conversation_model.dart';
import '../widgets/chat_header_widget.dart';
import '../widgets/chat_date_chip_widget.dart';
import '../widgets/chat_message_bubble_widget.dart';
import '../widgets/message_composer_widget.dart';

class ChatScreen extends StatelessWidget {
  final ChatConversationModel? conversation;

  const ChatScreen({super.key, this.conversation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔴 قراءة الآرجومنت بأمان مع توفير كائن افتراضي إذا فتحت الشاشة من الإعدادات أو بشكل مباشر
    final ChatConversationModel activeConversation = conversation ??
        (ModalRoute.of(context)?.settings.arguments as ChatConversationModel?) ??
        const ChatConversationModel(
          id: '0',
          peerName: 'الدعم الفني / المساعدة',
          lastMessage: '',
          timeLabel: '',
          isOnline: true,
        );

    return BlocProvider(
      create: (context) => ChatCubit()..loadMessages(),
      child: Scaffold(
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.backgroundColor,
        appBar: ChatHeaderWidget(
          conversation: activeConversation,
          onBack: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        return ListView(
                          padding:
                          const EdgeInsets.all(AppSizes.paddingMedium),
                          children: [
                            const ChatDateChipWidget(label: 'اليوم'),
                            ...state.messages.map(
                                  (m) => ChatMessageBubbleWidget(message: m),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      return MessageComposerWidget(
                        hasDraft: state.hasDraft,
                        onChanged: (val) =>
                            context.read<ChatCubit>().updateDraftStatus(val),
                        onSend: (val) =>
                            context.read<ChatCubit>().sendMessage(val),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}