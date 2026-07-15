import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/notifications_local_data_source.dart';
import '../models/notification_model.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  List<NotificationModel> _notifications = [];
  FilterType _currentFilter = FilterType.all;

  void loadNotifications() {
    emit(NotificationsLoading());
    _notifications = NotificationsLocalDataSource.getFakeNotifications();
    _updateUiState();
  }

  void changeFilter(FilterType filter) {
    _currentFilter = filter;
    _updateUiState();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((element) => element.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _updateUiState();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((element) => element.id == id);
    _updateUiState();
  }

  void _updateUiState() {
    List<NotificationModel> filtered = [];
    if (_currentFilter == FilterType.all) {
      filtered = List.from(_notifications);
    } else if (_currentFilter == FilterType.unread) {
      filtered = _notifications.where((n) => !n.isRead).toList();
    } else {
      filtered = _notifications.where((n) => n.isRead).toList();
    }

    emit(NotificationsLoaded(
      filteredNotifications: filtered,
      currentFilter: _currentFilter,
      totalCount: _notifications.length,
      importantCount: _notifications.where((n) => n.tags.contains('مهم')).length,
      readCount: _notifications.where((n) => n.isRead).length,
      unreadCount: _notifications.where((n) => !n.isRead).length,
    ));
  }
}