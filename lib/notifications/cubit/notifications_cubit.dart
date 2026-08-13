import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../widgets/notification_type_style.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationService _service;
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  NotificationsCubit(this._service) : super(NotificationsInitial()) {
    _listenToIncomingNotifications();
  }

  List<NotificationModel> _notifications = [];
  FilterType _currentFilter = FilterType.all;

  /// الاستماع التلقائي للإشعارات اللحظية أثناء فتح التطبيق
  void _listenToIncomingNotifications() {
    _fcmSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // عند وصول إشعار جديد، يُعاد تحديث القائمة تلقائياً في الخلفية
      refresh();
    });
  }

  /// أول تحميل — يعرض Loading كامل
  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      _notifications = await _service.getNotifications();
      _sort();
      _emitLoaded();
    } catch (e) {
      emit(NotificationsError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// سحب للتحديث — يحافظ على القائمة الظاهرة
  Future<void> refresh() async {
    if (state is! NotificationsLoaded) return loadNotifications();
    _emitLoaded(isRefreshing: true);
    try {
      _notifications = await _service.getNotifications();
      _sort();
      _emitLoaded();
    } catch (e) {
      _emitLoaded(actionError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  void changeFilter(FilterType filter) {
    _currentFilter = filter;
    _emitLoaded();
  }

  /// تحديث تفاؤلي: نعلّم كمقروء فوراً ثم نستدعي السيرفر، ونتراجع عند الفشل
  Future<void> markAsRead(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;

    final previous = _notifications[index];
    _notifications[index] = previous.copyWith(isRead: true);
    _emitLoaded();

    try {
      await _service.markAsRead(id);
    } catch (e) {
      _notifications[index] = previous;
      _emitLoaded(actionError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> markAllAsRead() async {
    final backup = List<NotificationModel>.from(_notifications);
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    _emitLoaded();

    try {
      await _service.markAllAsRead();
    } catch (e) {
      _notifications = backup;
      _emitLoaded(actionError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteNotification(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final removed = _notifications[index];
    _notifications.removeAt(index);
    _emitLoaded();

    try {
      await _service.deleteNotification(id);
    } catch (e) {
      _notifications.insert(index, removed);
      _emitLoaded(actionError: e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _sort() {
    _notifications.sort((a, b) {
      final da = DateTime.tryParse(a.createdAt);
      final db = DateTime.tryParse(b.createdAt);
      if (da == null || db == null) return 0;
      return db.compareTo(da); // الأحدث أولاً
    });
  }

  void _emitLoaded({bool isRefreshing = false, String? actionError}) {
    List<NotificationModel> filtered;
    switch (_currentFilter) {
      case FilterType.unread:
        filtered = _notifications.where((n) => !n.isRead).toList();
        break;
      case FilterType.read:
        filtered = _notifications.where((n) => n.isRead).toList();
        break;
      case FilterType.all:
        filtered = List.from(_notifications);
        break;
    }

    emit(NotificationsLoaded(
      filteredNotifications: filtered,
      currentFilter: _currentFilter,
      totalCount: _notifications.length,
      importantCount: _notifications
          .where((n) => resolveNotificationTypeStyle(n.type).important)
          .length,
      readCount: _notifications.where((n) => n.isRead).length,
      unreadCount: _notifications.where((n) => !n.isRead).length,
      isRefreshing: isRefreshing,
      actionError: actionError,
    ));
  }

  @override
  Future<void> close() {
    _fcmSubscription?.cancel();
    return super.close();
  }
}