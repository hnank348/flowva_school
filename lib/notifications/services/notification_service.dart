import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../models/notification_model.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  /// GET /api/Notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiService.get(ConstantApi.notifications);

      final isOkStatus =
          response.statusCode == 200 || response.statusCode == 201;

      if (isOkStatus && response.data is List) {
        final List<dynamic> raw = response.data;
        return raw.map((j) => NotificationModel.fromJson(j)).toList();
      }

      throw Exception('فشل جلب الإشعارات من السيرفر');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/Notifications/{id}/read
  Future<void> markAsRead(int id) async {
    try {
      await _apiService.patch(ConstantApi.markNotificationRead(id));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// PATCH /api/Notifications/read-all
  Future<void> markAllAsRead() async {
    try {
      await _apiService.patch(ConstantApi.markAllNotificationsRead);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// DELETE /api/Notifications/{id}/destroy (حذف ناعم — قابل للاسترجاع)
  Future<void> deleteNotification(int id) async {
    try {
      await _apiService.delete(ConstantApi.destroyNotification(id));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}