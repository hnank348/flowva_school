import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../models/chat_conversation_model.dart';

class ChatListTileWidget extends StatelessWidget {
  const ChatListTileWidget({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ChatConversationModel conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unread = conversation.hasUnread;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final surfaceColor = isDark ? AppColors.darkSurface : Colors.white;
    final outlineColor = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(bottom: BorderSide(color: outlineColor.withOpacity(0.3))),
        ),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, size: 28, color: primaryColor),
                ),
                if (conversation.isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceColor, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.peerName,
                        style: AppStyles.labelStyle.copyWith(
                          fontSize: AppSizes.fontSizeLabel + 1.0,
                          color: isDark ? Colors.white : AppColors.primaryText,
                        ),
                      ),
                      Text(
                        conversation.timeLabel,
                        style: AppStyles.labelStyle.copyWith(
                          fontSize: AppSizes.fontSizeLabel - 2.0,
                          color: unread ? primaryColor : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.labelStyle.copyWith(
                            fontWeight: unread ? FontWeight.bold : FontWeight.normal,
                            color: unread
                                ? (isDark ? Colors.white : AppColors.primaryText)
                                : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}