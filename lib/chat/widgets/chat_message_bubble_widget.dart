import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../models/chat_message_model.dart';

class ChatMessageBubbleWidget extends StatelessWidget {
  const ChatMessageBubbleWidget({super.key, required this.message});
  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium, vertical: 10),
        decoration: BoxDecoration(
          color: message.isSent ? primaryColor : (isDark ? AppColors.darkSurface : Colors.grey.shade100),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSizes.borderRadiusLarge),
            topRight: const Radius.circular(AppSizes.borderRadiusLarge),
            bottomLeft: Radius.circular(message.isSent ? AppSizes.borderRadiusLarge : 0),
            bottomRight: Radius.circular(message.isSent ? 0 : AppSizes.borderRadiusLarge),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: AppStyles.labelStyle.copyWith(
                fontWeight: FontWeight.normal,
                color: message.isSent ? Colors.white : (isDark ? Colors.white : AppColors.primaryText),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.timeLabel,
                  style: TextStyle(fontSize: 10, color: message.isSent ? Colors.white70 : AppColors.secondaryText),
                ),
                if (message.isSent) ...[
                  const SizedBox(width: 4),
                  Icon(message.isRead ? Icons.done_all_rounded : Icons.done_rounded, size: 12, color: Colors.white70),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}