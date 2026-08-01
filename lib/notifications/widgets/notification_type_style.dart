import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

class NotificationTypeStyle {
  final IconData icon;
  final Color color;
  final bool important;

  const NotificationTypeStyle({
    required this.icon,
    required this.color,
    this.important = false,
  });
}

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

/// تحويل createdAt القادم من السيرفر إلى نص مترجم بناءً على لغة التطبيق
String formatNotificationTime(String createdAt, BuildContext context) {
  final date = DateTime.tryParse(createdAt)?.toLocal();
  if (date == null) return createdAt;

  final diff = DateTime.now().difference(date);
  if (diff.inSeconds < 60) return context.tr('notif_time_now');
  if (diff.inMinutes < 60) {
    return context.tr('notif_time_minutes_ago').replaceAll('{minutes}', '${diff.inMinutes}');
  }
  if (diff.inHours < 24) {
    return context.tr('notif_time_hours_ago').replaceAll('{hours}', '${diff.inHours}');
  }
  if (diff.inDays < 7) {
    return context.tr('notif_time_days_ago').replaceAll('{days}', '${diff.inDays}');
  }

  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}