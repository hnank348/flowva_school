import 'package:dio/dio.dart';
import 'package:flowva_school/services/constant_api.dart';
import '../api_service.dart';

class LoginService {
  final ApiService _apiService = ApiService();

  void forceUpdateToken(String token) {
    _apiService.forceUpdateToken(token);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email.trim(),
        'password': password,
      });

      final response = await _apiService.post(
        ConstantApi.login,
        data: formData,
        tr: tr,
      );

      print('🌐 [LoginService] Response Data: ${response.data}');
      print('📊 [LoginService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 ||
          (response.statusCode == 201 && response.data['success'] == true);

      if (isSuccessStatus && response.data['data'] != null) {
        final innerData = response.data['data'];
        final String userType =
            innerData['user']?['user_type'] ?? innerData['user_type'] ?? '';

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
          'message': (response.data is Map ? response.data['message'] : null) ??
              tr('login_credentials_error_msg'),
        };
      }
    } on ApiException catch (e) {
      print('❌ [LoginService ApiException]: ${e.message} | Code: ${e.statusCode}');

      if (e.statusCode == 401) {
        return {
          'success': false,
          'message': e.message.isNotEmpty && e.message != tr('api_unexpected_error')
              ? e.message
              : tr('login_credentials_error_msg'),
        };
      }

      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      print('❌ [LoginService General Exception]: $e');
      return {
        'success': false,
        'message': tr('server_unreachable_msg'),
      };
    }
  }

  Future<void> sendFcmToken({
    required String fcmToken,
    String? userToken,
    required String Function(String key) tr,
  }) async {
    try {
      if (userToken != null && userToken.isNotEmpty) {
        _apiService.forceUpdateToken(userToken);
      }

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