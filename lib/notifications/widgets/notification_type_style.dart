import 'package:flutter/material.dart';

class NotificationTypeStyle {
  final IconData icon;
  final Color color;
  final bool important; // هل هذا النوع يُحتسب ضمن "التنبيهات المهمة"

  const NotificationTypeStyle({
    required this.icon,
    required this.color,
    this.important = false,
  });
}

/// ✅ نقطة التوسعة الوحيدة — عند ظهور نوع جديد من السيرفر، فقط أضف حالة هنا
NotificationTypeStyle resolveNotificationTypeStyle(String type) {
  switch (type.toLowerCase().trim()) {
    case 'announcement':
      return const NotificationTypeStyle(
          icon: Icons.campaign_rounded, color: Colors.purple);
    case 'absence':
      return const NotificationTypeStyle(
          icon: Icons.person_off_rounded, color: Colors.orange, important: true);
    case 'invoice':
      return const NotificationTypeStyle(
          icon: Icons.account_balance_wallet_rounded,
          color: Colors.red,
          important: true);
    case 'results':
      return const NotificationTypeStyle(
          icon: Icons.assignment_turned_in_rounded, color: Colors.blue);
    case 'schoolevent':
      return const NotificationTypeStyle(
          icon: Icons.celebration_rounded, color: Colors.green);
    case 'busupdate':
      return const NotificationTypeStyle(
          icon: Icons.directions_bus_rounded, color: Colors.teal);
    case 'alert':
    case 'urgent':
      return const NotificationTypeStyle(
          icon: Icons.warning_amber_rounded, color: Colors.red, important: true);
    case 'test':
      return const NotificationTypeStyle(
          icon: Icons.bug_report_outlined, color: Colors.blueGrey);
    default:
      return const NotificationTypeStyle(
          icon: Icons.notifications_rounded, color: Colors.blueGrey);
  }
}

/// تحويل createdAt القادم من السيرفر إلى نص عربي مقروء
String formatNotificationTime(String createdAt) {
  final date = DateTime.tryParse(createdAt)?.toLocal();
  if (date == null) return createdAt;

  final diff = DateTime.now().difference(date);
  if (diff.inSeconds < 60) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} ساعة';
  if (diff.inDays < 7) return 'قبل ${diff.inDays} يوم';

  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}
