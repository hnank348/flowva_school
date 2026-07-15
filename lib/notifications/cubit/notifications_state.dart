import '../models/notification_model.dart';

enum FilterType { all, unread, read }

abstract class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> filteredNotifications;
  final FilterType currentFilter;
  final int totalCount;
  final int importantCount;
  final int readCount;
  final int unreadCount;

  const NotificationsLoaded({
    required this.filteredNotifications,
    required this.currentFilter,
    required this.totalCount,
    required this.importantCount,
    required this.readCount,
    required this.unreadCount,
  });
}