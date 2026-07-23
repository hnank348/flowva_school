import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../models/notification_model.dart';
import '../widgets/notification_filter_tabs.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notification_statistics_cards.dart';
import '../widgets/notifications_empty_view.dart';

class SupervisorNotificationsScreen extends StatelessWidget {
  const SupervisorNotificationsScreen({super.key});

  // بيانات المشرف — لاحقاً تُستبدل بـ API حقيقي
  static List<NotificationModel> _seedData() => const [
    NotificationModel(
      id: '1',
      title: 'غياب معلم',
      body: 'المعلم أحمد حسن غائب اليوم في الحصة الثانية بدون إذن مسبق.',
      time: 'منذ 10 دقائق',
      isRead: false,
      type: NotificationType.teacherAbsence,
      studentName: 'أحمد حسن',
      tags: ['مهم'],
    ),
    NotificationModel(
      id: '2',
      title: 'تسجيل طالب جديد',
      body: 'تم تسجيل الطالب "يوسف محمود" في الصف السادس - شعبة أ.',
      time: 'منذ ساعة',
      isRead: false,
      type: NotificationType.newRegistration,
      studentName: 'يوسف محمود',
    ),
    NotificationModel(
      id: '3',
      title: 'تعديل بجدول الحصص',
      body: 'تم تعديل جدول حصص شعبة (7-ب) ليوم الأربعاء القادم.',
      time: 'منذ 3 ساعات',
      isRead: true,
      type: NotificationType.scheduleChange,
    ),
    NotificationModel(
      id: '4',
      title: 'ملاحظة سلوكية',
      body: 'تسجيل ملاحظة تأخر متكرر للطالب "سامر خالد".',
      time: 'أمس',
      isRead: true,
      type: NotificationType.studentIssue,
      studentName: 'سامر خالد',
      tags: ['مهم'],
    ),
    NotificationModel(
      id: '5',
      title: 'إعلان إداري',
      body: 'اجتماع طارئ لجميع المشرفين غداً الساعة العاشرة صباحاً.',
      time: 'منذ يومين',
      isRead: true,
      type: NotificationType.importantAlert,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      // ✅ نفس الـ Cubit تماماً، بس نمرر بيانات المشرف
      create: (context) =>
      NotificationsCubit(seedNotifications: _seedData())..loadNotifications(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
          body: SafeArea(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                if (state is NotificationsLoaded) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                            color: isDark ? Colors.white : AppColors.primaryText,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مركز إشعارات المشرف',
                                  style: AppStyles.titleStyle.copyWith(
                                    fontSize: AppSizes.fontSizeSubtitle + 3.0,
                                    color: isDark ? Colors.white : AppColors.primaryText,
                                  ),
                                ),
                                Text(
                                  'متابعة الحضور والتسجيلات والتنبيهات الإدارية',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: AppSizes.fontSizeLabel + 1.0,
                                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // ✅ نفس الويدجت بالضبط
                      NotificationStatisticsCards(
                        total: state.totalCount,
                        important: state.importantCount,
                        read: state.readCount,
                        unread: state.unreadCount,
                      ),
                      const SizedBox(height: 16),

                      // ✅ نفس الويدجت بالضبط
                      NotificationFilterTabs(
                        selectedFilter: state.currentFilter,
                        onFilterChanged: (filter) =>
                            context.read<NotificationsCubit>().changeFilter(filter),
                      ),
                      const SizedBox(height: 16),

                      state.filteredNotifications.isEmpty
                          ? const NotificationsEmptyView()
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = state.filteredNotifications[index];
                          // ✅ نفس الكارد بالضبط
                          return NotificationItemCard(
                            notification: notification,
                            onDelete: () => context
                                .read<NotificationsCubit>()
                                .deleteNotification(notification.id),
                            onMarkAsRead: () => context
                                .read<NotificationsCubit>()
                                .markAsRead(notification.id),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const NotificationsEmptyView();
              },
            ),
          ),
        ),
      ),
    );
  }
}