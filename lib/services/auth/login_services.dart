import 'package:dio/dio.dart';
import 'package:flowva_school/services/constant_api.dart';
import '../api_service.dart';

class LoginService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _apiService.post(
        ConstantApi.login,
        data: formData,
        tr: tr,
      );

      print('🌐 [LoginService] Response Data: ${response.data}');
      print('📊 [LoginService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || (response.statusCode == 201 && response.data['success'] == true);

      if (isSuccessStatus) {
        final innerData = response.data['data'];

        final String userType = innerData['user']?['user_type'] ?? innerData['user_type'] ?? '';

        return {
          'success': true,
          'message': response.data['message'] ?? tr('login_success_msg'),
          'token': innerData['token'] ?? '',
          'user_type': userType,
          'data': innerData,
        };
      } else {
        return {
          'success': false,
          'message': (response.data is Map ? response.data['message'] : null) ?? tr('login_credentials_error_msg'),
        };
      }
    } catch (e) {
      print('❌ [LoginService Exception]: $e');
      return {
        'success': false,
        'message': tr('server_unreachable_msg'),
      };
    }
  }

  // 🟢 تم التصحيح: إزالة context.tr وتمرير tr كـ Parameter إجباري
  Future<void> sendFcmToken({
    required String fcmToken,
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.post(
        '${ConstantApi.baseApi}/users/fcm-token',
        data: {'fcm_token': fcmToken},
        tr: tr,
      );
      print('🔔 [LoginService] FCM Token Update Status: ${response.statusCode}');
    } catch (e) {
      print('❌ [LoginService] Failed to send FCM Token: $e');
    }
  }
}