import 'package:dio/dio.dart';
import 'package:flowva_school/services/constant_api.dart';
import '../api_service.dart';

class ChangePasswordService {
  final ApiService _apiService;

  ChangePasswordService(this._apiService);

  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final formData = FormData.fromMap({
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });

      final response = await _apiService.post(
        ConstantApi.changePassword(userId),
        data: formData,
      );

      print('🌐 [ChangePasswordService] Response: ${response.data}');
      print('📊 [ChangePasswordService] Status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to change password',
        };
      }
    } on DioException catch (e) {
      String message = 'Server is unreachable. Make sure it is running.';

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
      return {'success': false, 'message': 'Server is unreachable. Make sure it is running.'};
    }
  }
}