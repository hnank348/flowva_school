import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/constant_api.dart';
import '../api_service.dart';

class ChangePasswordService {
  final ApiService _apiService;

  ChangePasswordService(this._apiService);

  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String newPassword,
    required String newPasswordConfirmation,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });

      final response = await _apiService.post(
        ConstantApi.changePassword(userId),
        data: formData,
        tr: context.tr,
      );

      print('🌐 [ChangePasswordService] Response: ${response.data}');
      print('📊 [ChangePasswordService] Status: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? tr('change_password_success_msg'),
        };
      } else {
        return {
          'success': false,
          'message': (response.data is Map ? response.data['message'] : null) ?? tr('change_password_fail_msg'),
        };
      }
    } on DioException catch (e) {
      String message = tr('server_unreachable_msg');

      if (e.response != null && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
      }

      print('❌ [ChangePasswordService Exception]: $message');
      return {'success': false, 'message': message};
    } catch (e) {
      print('❌ [ChangePasswordService Exception]: $e');
      return {'success': false, 'message': tr('server_unreachable_msg')};
    }
  }
}