import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class LogoutService {
  final ApiService _apiService;

  LogoutService(this._apiService);

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post(
        ConstantApi.logout,
      );

      print('🌐 [LogoutService] Response Data: ${response.data}');
      print('📊 [LogoutService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {'success': true, 'message': response.data['message'] ?? ''};
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'فشل تسجيل الخروج',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }
}