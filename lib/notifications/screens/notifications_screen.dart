import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_filter_tabs.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notification_statistics_cards.dart';
import '../widgets/notifications_empty_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => NotificationsCubit()..loadNotifications(),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                  'مركز الإشعارات',
                                  style: AppStyles.titleStyle.copyWith(
                                    fontSize: AppSizes.fontSizeSubtitle + 3.0,
                                    color: isDark ? Colors.white : AppColors.primaryText,
                                  ),
                                ),
                                Text(
                                  'جميع التنبيهات والرسائل الخاصة بأبنائك',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: AppSizes.fontSizeLabel +1.0 ,
                                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      NotificationStatisticsCards(
                        total: state.totalCount,
                        important: state.importantCount,
                        read: state.readCount,
                        unread: state.unreadCount,
                      ),
                      
                      const SizedBox(height: 16),
                      NotificationFilterTabs(
                        selectedFilter: state.currentFilter,
                        onFilterChanged: (filter) {
                          context.read<NotificationsCubit>().changeFilter(filter);
                        },
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
                                return NotificationItemCard(
                                  notification: notification,
                                  onDelete: () {
                                    context.read<NotificationsCubit>().deleteNotification(notification.id);
                                  },
                                  onMarkAsRead: () {
                                    context.read<NotificationsCubit>().markAsRead(notification.id);
                                  },
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