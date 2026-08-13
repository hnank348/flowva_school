import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class LogoutService {
  final ApiService _apiService;

  LogoutService(this._apiService);

  Future<Map<String, dynamic>> logout({
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.post(
        ConstantApi.logout,
        tr: context.tr,
      );

      print('🌐 [LogoutService] Response Data: ${response.data}');
      print('📊 [LogoutService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return {'success': true, 'message': response.data['message'] ?? ''};
      }

      return {
        'success': false,
        'message': (response.data is Map ? response.data['message'] : null) ?? tr('logout_failed_msg'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }
}