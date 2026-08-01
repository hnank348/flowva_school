import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../models/chat_conversation_model.dart';

class ChatHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeaderWidget({
    super.key,
    required this.conversation,
    required this.onBack,
  });

  final ChatConversationModel conversation;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final elementColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return AppBar(
      backgroundColor: appBarColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.borderRadiusLarge),
          bottomRight: Radius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: Colors.white,
                onPressed: onBack,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, color: elementColor),
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    conversation.peerName,
                    style: AppStyles.labelStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    conversation.isOnline ? 'نشط الآن' : 'غير متصل',
                    style: AppStyles.labelStyle.copyWith(
                      fontSize: AppSizes.fontSizeLabel - 3.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}