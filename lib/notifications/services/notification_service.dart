import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../models/notification_model.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiService.get(ConstantApi.notifications,tr: context.tr,);

      final isOkStatus =
          response.statusCode == 200 || response.statusCode == 201;

      if (isOkStatus && response.data != null) {
        List<dynamic> raw = [];

        if (response.data is Map && response.data['data'] is List) {
          raw = response.data['data'];
        } else if (response.data is List) {
          raw = response.data;
        }

        return raw.map((j) => NotificationModel.fromJson(j)).toList();
      }

      throw Exception('فشل جلب الإشعارات من السيرفر');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _apiService.patch(ConstantApi.markNotificationRead(id),tr: context.tr,);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiService.patch(ConstantApi.markAllNotificationsRead,tr: context.tr,);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _apiService.delete(ConstantApi.destroyNotification(id),tr: context.tr,);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}