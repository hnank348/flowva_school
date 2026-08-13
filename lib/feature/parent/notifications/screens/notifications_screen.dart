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
    
    final appBarColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final contentColor = isDark ? Colors.black : Colors.white;
    final subTitleColor = isDark ? Colors.black87.withOpacity(0.65) : Colors.white70;

    return BlocProvider(
      create: (context) => NotificationsCubit()..loadNotifications(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: appBarColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: contentColor,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'مركز الإشعارات',
                      style: AppStyles.titleStyle.copyWith(
                        fontSize: AppSizes.fontSizeSubtitle,
                        color: contentColor,
                      ),
                    ),
                    Text(
                      'جميع التنبيهات والرسائل الخاصة بأبنائك',
                      style: AppStyles.labelStyle.copyWith(
                        fontSize: AppSizes.fontSizeLabel ,
                        fontWeight: FontWeight.normal,
                        color: subTitleColor,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppSizes.borderRadiusExtraLarge - 8.0),
                    bottomRight: Radius.circular(AppSizes.borderRadiusExtraLarge - 8.0),
                  ),
                ),
                toolbarHeight: 70,
              ),
              body: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Builder(
                      builder: (context) {
                        if (state is NotificationsLoading) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }

                        if (state is NotificationsLoaded) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                            children: [
                              const SizedBox(height: AppSizes.paddingLarge),
                              NotificationStatisticsCards(
                                total: state.totalCount,
                                important: state.importantCount,
                                read: state.readCount,
                                unread: state.unreadCount,
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),
                              NotificationFilterTabs(
                                selectedFilter: state.currentFilter,
                                onFilterChanged: (filter) {
                                  context.read<NotificationsCubit>().changeFilter(filter);
                                },
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),
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
                              const SizedBox(height: AppSizes.paddingLarge),
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
          },
        ),
      ),
    );
  }
}