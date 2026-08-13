import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/messages_cubit.dart';
import '../cubit/messages_state.dart';
import '../widgets/messages_header_widget.dart';
import '../widgets/chat_list_tile_widget.dart';
import '../widgets/messages_empty_widget.dart';
import 'chat_screen.dart'; 

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => MessagesCubit()..loadConversations(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
        body: Column(
          children: [
            const MessagesHeaderWidget(), 
            Expanded( 
              child: BlocBuilder<MessagesCubit, MessagesState>(
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return const Center(child: CircularProgressIndicator.adaptive());
                  }
                  if (state is MessagesLoaded) {
                    final list = state.visibleConversations;
                    if (list.isEmpty) return const MessagesEmptyWidget();
                    
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      itemBuilder: (context, i) => ChatListTileWidget(
                        conversation: list[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                              settings: RouteSettings(arguments: list[i]),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const MessagesEmptyWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}