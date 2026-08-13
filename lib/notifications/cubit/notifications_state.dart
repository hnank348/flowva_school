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

  /// يظهر شريط تحميل صغير أثناء التحديث في الخلفية (سحب للتحديث / تعليم كمقروء)
  final bool isRefreshing;

  /// خطأ عملية جانبية (مثلاً فشل الحذف) بدون إخفاء القائمة
  final String? actionError;

  const NotificationsLoaded({
    required this.filteredNotifications,
    required this.currentFilter,
    required this.totalCount,
    required this.importantCount,
    required this.readCount,
    required this.unreadCount,
    this.isRefreshing = false,
    this.actionError,
  });
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
}