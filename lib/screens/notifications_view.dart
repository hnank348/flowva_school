import 'package:flutter/material.dart';
import '../widget/common_widgets.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationCard(
            title: 'اختبار جديد',
            message: 'تم إنشاء اختبار رياضيات للصف 9-أ',
            time: 'منذ 5 دقائق',
            icon: Icons.assignment,
            color: colorScheme.primary,
            isUnread: true,
          ),
          NotificationCard(
            title: 'تذكير بالحضور',
            message: 'يرجى تسجيل حضور الصفوف اليوم',
            time: 'منذ ساعة',
            icon: Icons.access_time,
            color: colorScheme.primary,
            isUnread: true,
          ),
          NotificationCard(
            title: 'اجتماع أولياء الأمور',
            message: 'الاجتماع يوم الأحد القادم الساعة 10 صباحاً',
            time: 'منذ يومين',
            icon: Icons.event,
            color: Colors.green,
            isUnread: false,
          ),
          NotificationCard(
            title: 'تقرير الأداء',
            message: 'تم نشر تقرير الأداء الشهري',
            time: 'منذ 3 أيام',
            icon: Icons.bar_chart,
            color: colorScheme.primary,
            isUnread: false,
          ),
          NotificationCard(
            title: 'رسالة من الموجه',
            message: 'الموجه التربوي يريد مناقشة نتائج الطلاب',
            time: 'منذ أسبوع',
            icon: Icons.chat,
            color: colorScheme.primary,
            isUnread: false,
          ),
        ],
      ),
    );
  }

  // NotificationCard moved to shared widgets
}
