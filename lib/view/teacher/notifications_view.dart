import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../widget/common_widgets.dart';
import 'teacher_sub_screen_app_bar.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(
        title: context.tr('teacher_notifications_title'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationCard(
            title: context.tr('teacher_notif_new_exam'),
            message: context.tr('teacher_notif_new_exam_msg'),
            time: context.tr('teacher_notif_time_5m'),
            icon: Icons.assignment_outlined,
            color: colorScheme.primary,
            isUnread: true,
          ),
          NotificationCard(
            title: context.tr('teacher_notif_parent_meeting'),
            message: context.tr('teacher_notif_parent_meeting_msg'),
            time: context.tr('teacher_notif_time_2d'),
            icon: Icons.event_outlined,
            color: colorScheme.primary,
            isUnread: false,
          ),
          NotificationCard(
            title: context.tr('teacher_performance_reports'),
            message: context.tr('teacher_notif_report_msg'),
            time: context.tr('teacher_notif_time_3d'),
            icon: Icons.bar_chart_outlined,
            color: colorScheme.primary,
            isUnread: false,
          ),
          NotificationCard(
            title: context.tr('teacher_supervisor_messages'),
            message: context.tr('teacher_notif_supervisor_msg'),
            time: context.tr('teacher_notif_time_1w'),
            icon: Icons.chat_bubble_outline,
            color: colorScheme.primary,
            isUnread: false,
          ),
        ],
      ),
    );
  }
}
