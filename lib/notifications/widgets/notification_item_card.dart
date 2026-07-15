import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../models/notification_model.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsRead;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onDelete,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tealColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final typeData = _getTypeDetails(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium, vertical: 10),
      decoration: BoxDecoration(
        color: !notification.isRead 
            ? tealColor.withOpacity(0.2) 
            : (isDark ? AppColors.darkSurface : Colors.white),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: !notification.isRead 
              ? tealColor 
              : (isDark ? AppColors.darkOutlineColor : AppColors.outlineColor.withOpacity(0.85)),
          width: !notification.isRead ? 1.5 : 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: typeData['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(typeData['icon'], color: typeData['color'], size: 22),
          ),
          const SizedBox(width: 9),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontSizeLabel +1.0,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primaryText,
                        ),
                      ),
                    ),
                    if (notification.tags.contains('مهم'))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(color: AppColors.errorRed, borderRadius: BorderRadius.circular(4)),
                        child: const Text('مهم', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSizeLabel ,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.primaryText.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      notification.time, 
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText)
                    ),
                    if (notification.studentName != null) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.person_outline_rounded, size: 12, color: tealColor),
                      const SizedBox(width: 2),
                      Text(
                        notification.studentName!, 
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: tealColor, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!notification.isRead) ...[
                IconButton(
                  onPressed: onMarkAsRead,
                  icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 20),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(2), 
                ),
              ],
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.errorRed, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getTypeDetails(NotificationType type) {
    switch (type) {
      case NotificationType.absence: return {'icon': Icons.person_off_rounded, 'color': Colors.orange};
      case NotificationType.invoice: return {'icon': Icons.account_balance_wallet_rounded, 'color': AppColors.errorRed};
      case NotificationType.results: return {'icon': Icons.assignment_turned_in_rounded, 'color': Colors.blue};
      case NotificationType.schoolEvent: return {'icon': Icons.celebration_rounded, 'color': Colors.green};
      case NotificationType.busUpdate: return {'icon': Icons.directions_bus_rounded, 'color': Colors.teal};
      case NotificationType.importantAlert: return {'icon': Icons.campaign_rounded, 'color': Colors.purple};
    }
  }
}