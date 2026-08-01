import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import 'package:flowva_school/app_localizations.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_filter_tabs.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notification_statistics_cards.dart';
import '../widgets/notifications_empty_view.dart';

/// ✅ شاشة إشعارات المشرف — بيانات حقيقية من الـ API ومترجمة بالكامل.
class SupervisorNotificationsScreen extends StatefulWidget {
  const SupervisorNotificationsScreen({super.key});

  @override
  State<SupervisorNotificationsScreen> createState() =>
      _SupervisorNotificationsScreenState();
}

class _SupervisorNotificationsScreenState
    extends State<SupervisorNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    if (cubit.state is NotificationsInitial) {
      cubit.loadNotifications();
    } else {
      cubit.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.backgroundColor,
      body: SafeArea(
        child: BlocConsumer<NotificationsCubit, NotificationsState>(
          listenWhen: (prev, curr) =>
          curr is NotificationsLoaded && curr.actionError != null,
          listener: (context, state) {
            final message = (state as NotificationsLoaded).actionError!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.errorRed,
                content: Text(
                  message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            );
          },
          builder: (context, state) {
            final cubit = context.read<NotificationsCubit>();

            if (state is NotificationsLoading ||
                state is NotificationsInitial) {
              return const Center(
                  child: CircularProgressIndicator.adaptive());
            }

            if (state is NotificationsError) {
              return _ErrorView(
                message: state.message,
                onRetry: cubit.loadNotifications,
              );
            }

            state as NotificationsLoaded;

            return RefreshIndicator.adaptive(
              onRefresh: cubit.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium),
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 22),
                        color: isDark ? Colors.white : AppColors.primaryText,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('notif_center_title'),
                              style: AppStyles.titleStyle.copyWith(
                                fontSize: AppSizes.fontSizeSubtitle + 3.0,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primaryText,
                              ),
                            ),
                            Text(
                              context.tr('notif_center_subtitle'),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: AppSizes.fontSizeLabel + 1.0,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.unreadCount > 0)
                        TextButton(
                          onPressed: cubit.markAllAsRead,
                          child: Text(
                            context.tr('notif_mark_all_read'),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (state.isRefreshing)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: LinearProgressIndicator(minHeight: 2),
                    ),
                  NotificationStatisticsCards(
                    total: state.totalCount,
                    important: state.importantCount,
                    read: state.readCount,
                    unread: state.unreadCount,
                  ),
                  const SizedBox(height: 16),
                  NotificationFilterTabs(
                    selectedFilter: state.currentFilter,
                    onFilterChanged: cubit.changeFilter,
                  ),
                  const SizedBox(height: 16),
                  if (state.filteredNotifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: NotificationsEmptyView(),
                    )
                  else
                    ...state.filteredNotifications.map(
                          (n) => NotificationItemCard(
                        notification: n,
                        onMarkAsRead: () => cubit.markAsRead(n.id),
                        onDelete: () => cubit.deleteNotification(n.id),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 56, color: AppColors.errorRed),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                context.tr('btn_retry'),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}